---
title: Train a Recurrent Neural Network (RNN) with Poutyne
author: David Beauchemin
date: '2020-08-18'
slug: machine learning
type: post
categories: ["python", "machine learning"]
tags: []
description: "Address tagging with a RNN"
featured: "OpenLayer_YoutubeBanner.jpg"
featuredpath: "img/headers/"
---

> In this article, we will train an RNN, or more precisely, an LSTM, to predict the sequence of tags associated with a 
given address, known as parsing address. 

> Also, the code (only) is available in [this Google Colab Jupyter notebook](https://colab.research.google.com/github/dot-layer/blog/blob/post%2Fdb_sequence_training_poutyne/content/blog/2020-08-19-train-a-sequence-model-with-poutyne/article_notebook.ipynb#scrollTo=c1JxpCRsQN0e).

> Before starting this article, I would like to disclaim that this tutorial is greatly inspired by a online tutorial I 
created for Poutyne framework. Also, the content is based on a recent article I wrote with Marouane Yassine. However, 
there are differences between the present work and the two others, I've tried to put more insights for the less technical reader in this one.
>
Sequential data, such as addresses, are pieces of information that are deliberately given in a specific order. In other words, they are sequences with a particular structure; and knowing this structure is crucial for predicting the missing entries of a given truncated sequence. For example, 
when writing an address, we know, in Canada, that after the civic number (e.g. 420), we have the street name (e.g. du Lac).
Hence, if one was asked to complete an address containing only a number, she could reasonably assume that the next information that should be added to the sequence is a street name. Various modelling approaches have been proposed to make predictions over sequential data. Still, more recently, deep learning models known as Recurrent Neural Network (RNN) has been introduced for this type of data.

The main purpose of this article is to discuss the various tricks (e.g., padding and packing) that are required for training an RNN. Before we do that, let us define our "address" problem more formally and elaborate on what RNNs (and LSTMs) actually are.
state our problem, and later on, we will discuss what an actual RNN or LSTM is.

## Address Tagging
Address tagging is the task of detecting and tagging the different parts of an address such as the civic number, 
the street name or the postal code (or zip code). The following figure shows an example of such a tagging.

![address parsing canada](address_parsing.png)

Since addresses are written in a predetermined sequence, RNN is the best way to crack this problem. However, to decode the output of the RNN, we also need another component, a fully-connected layer. 
Our architecture will therefore consist of an RNN and a fully-connected layer. 

## RNN
Speaking of RNN, what is it?

In brief, RNN is a neural network in which connections between nodes form a temporal sequence. It means that this type of network
allows previous outputs to be used as inputs for the next prediction
([For more about RNN](https://stanford.edu/~shervine/teaching/cs-230/cheatsheet-recurrent-neural-networks)). 

For the present purpose, we do not use the vanilla RNN, but a variant of it known as long short-term memory (LSTM) network. This latter, which involves components called gates, is often preferred over its competitors due to its better stability with respect to gradient update (vanishing and exploding gradient).
better stability with gradient update (vanishing and exploding gradient) by using gates 
([to learn more about LSTMs](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)). 

Also, for now, let's simply use a single layer unidirectional LSTM. We will, later on, explore the use of more layers and bidirectional approach. 

### Word Embeddings

Since our data is text, we will use a well-known word encoding technique, word embeddings. Word embeddings are vector
representations of words. The main hypothesis underlying their use is that there exists a linear relation between words. For example, the linear relation
between the word `king` and `queen` is gender. So logically, if we remove the vector corresponding to `male` to the one for `king`, and then add the vector for
`female`, we should obtain the vector corresponding to `queen`. That being said, those kind of representation usually are in dimension `300`, which
makes it impossible for humans to reason about them. Still, the idea is there but in a larger dimension space.

So our LSTM's input and hidden state dimensions will be of the same size as the vectors of embedded words. 
For the present purpose, we will use the
[French pre trained](https://fasttext.cc/docs/en/crawl-vectors.html) fastText embeddings of dimension `300`. 

### The Pytorch Model

Let us first import all the required packages.

```python
import os
import pickle

import fasttext
import fasttext.util
import requests
import torch
import torch.nn as nn
import torch.optim as optim
from poutyne import set_seeds
from poutyne.framework import Experiment
from torch.nn.functional import cross_entropy
from torch.nn.utils.rnn import pad_packed_sequence, pack_padded_sequence, pad_sequence
from torch.utils.data import DataLoader
```

Now, let's create a single (i.e. one layer) unidirectional LSTM with `input_size` and `hidden_size` of `300`. We 
will explore later on the effect of stacking more layers and of using a bidirectional approach.

> See [here](https://discuss.pytorch.org/t/could-someone-explain-batch-first-true-in-lstm/15402) the explanation why we use the `batch_first` argument.

```python
dimension = 300
num_layer = 1
bidirectional = False

lstm_network = nn.LSTM(input_size=dimension,
                       hidden_size=dimension,
                       num_layers=num_layer,
                       bidirectional=bidirectional,
                       batch_first=True)
```


## Fully-connected Layer
Since the output of the LSTM network is of dimension `300`, we will use a fully-connected layer to map it into
a space of equal dimension to that of the tag space (i.e. number of tags to predict), that is 8. 

Finally, since we want to predict the most probable tokens, we will apply the softmax function on this layer
(see [here](https://en.wikipedia.org/wiki/Softmax_function) if softmax does not ring a bell).


```python
input_dim = dimension #the output of the LSTM
tag_dimension = 8

fully_connected_network = nn.Linear(input_dim, tag_dimension)
```

## Training Constants

Now, let's set our training constants. We first specify a CUDA (GPU) device for training (using a CPU is way too long, 
if you don't have one, you can use a Google Colab notebook). 

Secondly, we set the batch size (i.e. the number of elements to see before updating the model), the learning rate for the optimizer
and the number of epochs.

```python
device = torch.device("cuda:0")

batch_size = 128
lr = 0.1

epoch_number = 10
```

We also need to set Pythons's, NumPy's and PyTorch's seeds using the Poutyne function so that our training is (almost) reproducible.

> See [here](https://determined.ai/blog/reproducibility-in-ml/) for more explanation of why setting seed does not guarantee reproducibility.

```python
set_seeds(42)
```

## The Dataset
The dataset consists of `1,010,987` complete French and English Canadian address and their associated address components tags.
Here's an example `("420 rue des Lilas Ouest, Québec, G1V 2V3", [StreetNumber, StreetName, StreetName, StreetName, 
Orientation, City, PostalCode, PostalCode])`.

Now let's download our dataset; for simplicity, the data was already split into an 80-20 train-valid and a `100,000` test set. 
Also note that the dataset was pickled for simplicity (using a Python `list`). Here is the code to download it.

```python
def download_data(saving_dir, data_type):
    """
    Function to download the dataset using data_type to specify if we want the train, valid or test.
    """

    # hardcoded url to download the pickled dataset
    root_url = "https://dot-layer.github.io/blog-external-assets/train_rnn/{}.p"

    url = root_url.format(data_type)
    r = requests.get(url)
    os.makedirs(saving_dir, exist_ok=True)

    open(os.path.join(saving_dir, f"{data_type}.p"), 'wb').write(r.content)
    
download_data('./data/', "train")
download_data('./data/', "valid")
download_data('./data/', "test")
```

Now let's load in memory the data.

```python
# load the data

train_data = pickle.load(open("./data/train.p", "rb"))  # 728,789 examples
valid_data = pickle.load(open("./data/valid.p", "rb"))  # 182,198 examples
test_data = pickle.load(open("./data/test.p", "rb"))  # 100,000 examples
```

As we explained before, the (train) dataset is a list of `728,789` tuples where the first element is the full address, and the second is a list of the tag (the ground truth).

```python
train_data[0:2]
```

> (the output)

![data_snapshot](data_snapshot.png)

### Vectorize the Dataset

Since we used word embeddings as our encoded representation of the words, we need to *convert* the address into word vector. In order to do that, we will use a vectorizer. This embedding vectorizer will extract, for each word, the embedding value based on the pre-trained French fastText model.

```python
class EmbeddingVectorizer:
    def __init__(self):
        """
        Embedding vectorizer
        """
        fasttext.util.download_model('fr', if_exists='ignore')
        self.embedding_model = fasttext.load_model("./cc.fr.300.bin")

    def __call__(self, address):
        """
        Convert address to embedding vectors
        :param address: The address to convert
        :return: The embeddings vectors
        """
        embeddings = []
        for word in address.split():
            embeddings.append(self.embedding_model[word])
        return embeddings
     
embedding_vectorizer = EmbeddingVectorizer()
```

We also need to apply a similar operation to the address tags (e.g. StreeNumber, StreetName). 
This time, however, the vectorizer needs to convert the tags into categorical values (e.g. 0, 1). 

For simplicity, we will use a `DatasetVectorizer` class that will apply the vectorizing process using both 
the embedding and the address vectorize process.

```python
class DatasetVectorizer:
    def __init__(self, embedding_vectorizer):
        self.embedding_vectorizer = embedding_vectorizer
        self.tags_set = {
            "StreetNumber": 0,
            "StreetName": 1,
            "Unit": 2,
            "Municipality": 3,
            "Province": 4,
            "PostalCode": 5,
            "Orientation": 6,
            "GeneralDelivery": 7
        }

    def vectorize(self, data):  # We vectorize inplace
        for idx, item in enumerate(data):
            data[idx] = self._item_vectorizing(item)

    def _item_vectorizing(self, item):
        address = item[0]
        address_vector = self.embedding_vectorizer(address)

        tags = item[1]
        idx_tags = self._convert_tags_to_idx(tags)

        return address_vector, idx_tags

    def _convert_tags_to_idx(self, tags):
        idx_tags = []
        for tag in tags:
            idx_tags.append(self.tags_set[tag])
        return idx_tags

dataset_vectorizer = DatasetVectorizer(embedding_vectorizer)
```  

Now, let's vectorize our dataset.

```python
dataset_vectorizer.vectorize(train_data)
dataset_vectorizer.vectorize(valid_data)
dataset_vectorizer.vectorize(test_data)
```

### DataLoader
> We use a first trick, ``padding``.

Now, since the addresses are not all of the same size, it is impossible to batch them together; recall that all tensor elements must have the same lengths. But there is a trick, padding!

The idea is simple. We add *empty* tokens at the end of each sequence up to the longest one in a batch. For the word vectors, we add vectors of 0 as padding. For the tag indices, we pad with -100's. We do so because the [cross-entropy loss](https://pytorch.org/docs/stable/generated/torch.nn.CrossEntropyLoss.html#torch.nn.CrossEntropyLoss) and the accuracy metric both ignore targets with values of -100.

To do this padding, we use the `collate_fn` argument of the [PyTorch `DataLoader`](https://pytorch.org/docs/stable/data.html#torch.utils.data.DataLoader), and on running time, that process will be done. One thing to keep in mind when treating padded sequences is that their (original) length will be required to unpack them later on, in the forward pass. That way, we can pad and pack the sequence to minimize the training time (read [this good explanation](https://stackoverflow.com/questions/51030782/why-do-we-pack-the-sequences-in-pytorch) of why we pad and pack sequences).

```python
def pad_collate_fn(batch):
    """
    The collate_fn that can add padding to the sequences so all can have 
    the same length as the longest one.

    Args:
        batch (List[List, List]): The batch data, where the first element 
        of the tuple is the word idx and the second element are the target 
        label.

    Returns:
        A tuple (x, y). The element x is a tuple containing (1) a tensor of padded 
        word vectors and (2) their respective lengths of the sequences. The element 
        y is a tensor of padded tag indices. The word vectors are padded with vectors 
        of 0s and the tag indices are padded with -100s. Padding with -100 is done 
        because of the cross-entropy loss and the accuracy metric ignores 
        the targets with values -100.
    """

    # This gets us two lists of tensors and a list of integer. 
    # Each tensor in the first list is a sequence of word vectors.
    # Each tensor in the second list is a sequence of tag indices.
    # The list of integer consist of the lengths of the sequences in order.
    sequences_vectors, sequences_labels, lengths = zip(*[
        (torch.FloatTensor(seq_vectors), torch.LongTensor(labels), len(seq_vectors)) 
         for (seq_vectors, labels) in sorted(batch, key=lambda x: len(x[0]), reverse=True)
    ])

    lengths = torch.LongTensor(lengths)

    padded_sequences_vectors = pad_sequence(sequences_vectors, batch_first=True, padding_value=0)

    padded_sequences_labels = pad_sequence(sequences_labels, batch_first=True, padding_value=-100)

    return (padded_sequences_vectors, lengths), padded_sequences_labels
```

```python
train_loader = DataLoader(train_data, batch_size=batch_size, shuffle=True, collate_fn=pad_collate_fn)
valid_loader = DataLoader(valid_data, batch_size=batch_size, collate_fn=pad_collate_fn)
test_loader = DataLoader(test_data, batch_size=batch_size, collate_fn=pad_collate_fn)
```

## Full Network
> We use a second trick, ``packing``.

Since our sequences are of variable lengths and we want to be the most efficient possible by packing them, we cannot use the [PyTorch `nn.Sequential`](https://pytorch.org/docs/stable/generated/torch.nn.Sequential.html) class to define our model, so we define the forward pass for it to pack and unpack the sequences (again, you can read [this good explanation](https://stackoverflow.com/questions/51030782/why-do-we-pack-the-sequences-in-pytorch) of why we pad and pack sequences).

```python
class FullNetWork(nn.Module):
    def __init__(self, lstm_network, fully_connected_network):
        super().__init__()
        self.hidden_state = None
        
        self.lstm_network = lstm_network
        self.fully_connected_network = fully_connected_network
        
    def forward(self, padded_sequences_vectors, lengths):
        """
            Defines the computation performed at every call.
        """
        total_length = padded_sequences_vectors.shape[1]
        pack_padded_sequences_vectors = pack_padded_sequence(padded_sequences_vectors, lengths, batch_first=True)

        lstm_out, self.hidden_state = self.lstm_network(pack_padded_sequences_vectors)
        lstm_out, _ = pad_packed_sequence(lstm_out, batch_first=True, total_length=total_length)

        tag_space = self.fully_connected_network(lstm_out)
        return tag_space.transpose(-1, 1) # we need to transpose since it's a sequence

full_network = FullNetWork(lstm_network, fully_connected_network)
```

## Summary

So we have created an LSTM network (`lstm_network`) and a fully connected network (`fully_connected_network`), and we use both
components in the full network. The full network makes use of padded, packed sequences (defined in the forward pass), 
so we created the `pad_collate_fn` function to process the necessary work. The DataLoader will conduct that process. Finally, 
we will load the data using the vectorizer. This means that the addresses will be represented by word embeddings. 
Also, the address components will be converted into categorical value (from 0 to 7).


## The Training

Now that we have all the components for the network, let's define our Stochastic Gradient Descent 
([SGD](https://en.wikipedia.org/wiki/Stochastic_gradient_descent)) optimizer.

```python
optimizer = optim.SGD(full_network.parameters(), lr)
```

### Poutyne Experiment
> Disclaimer that I'm a dev on Poutyne, so I will present code using this framework. See the project [here](https://poutyne.org/).

Let's create our experiment using Poutyne for automatically logging in the project root directory (`./`). We will also set
the loss function and a batch metric (accuracy) to monitor the training.

```python
exp = Experiment("./", full_network, device=cuda_device, optimizer=optimizer,
                 loss_function=cross_entropy, batch_metrics=["acc"])
```

Using our experiment, we can now launch the training as simple as

```python
exp.train(train_loader, valid_generator=valid_loader, epochs=epoch_number)
```
It will take around 6 minutes per epochs, so around an hour for the complete training.

### Results
The next figure shows the loss and the accuracy during training (blue) and during validation (orange).
After 10 epochs, we obtain a validation loss and accuracy of `0.01981` and `99.54701` respectively, which is pretty
good for a first model. Also, we can see that our model did not seem to have overfitted.

![loss_acc](graph/training_graph.png)

## Bigger model

It seems like our model performed pretty well, but just for fun, let's unleash the full potential of LSTM using a
bidirectional approach (bi-LSTM). What it means is instead of _simply_ using a seeing the sequence from the start to the end, we
also train the model to see the sequence from the end to the start. It's important to state that the two directions are
not shared, meaning that we _see_ the sequence in one direction at the time, but we gather the information from both directions into the 
fully connected layer. That way, our model can get insight from both directions.

Instead of using only one layer, let's use an LSTM, which means that we use two layers of hidden state.

So, let's create the new LSTM and fully connected network.

```python
dimension = 300
num_layer = 2
bidirectional = True

lstm_network = nn.LSTM(input_size=dimension,
                       hidden_size=dimension,
                       num_layers=num_layer,
                       bidirectional=bidirectional,
                       batch_first=True)

input_dim = dimension * 2 #since bidirectional

fully_connected_network = nn.Linear(input_dim, tag_dimension)

full_network_bi_lstm = FullNetWork(lstm_network, fully_connected_network)
```
 
### Training
 
```python
exp_bi_lstm = Experiment("./", full_network_bi_lstm, device=cuda_device, optimizer=optimizer,
                 loss_function=cross_entropy, batch_metrics=["acc"])
exp_bi_lstm.train(train_loader, valid_generator=valid_loader, epochs=epoch_number)
```

### Results
Here are the last epoch validation results of the larger model. On the validation dataset,
we can see that we obtain a marginal gain of around `0.3` for the accuracy over the previous one. Not much of an improvement.

|   Model  | Bi-LSTM two layers |
|:--------:|:------------------:|
|   Loss   |    0.0050          |
| Accuracy |    99.8594         |

But now that we have our two trained models, let's use the test set as a final an **unique** steps of evaluating the performance.

```python
exp.test(test_loader)
exp_bi_lstm.test(test_loader)
```

The next table presents the results of the Bi-LSTM with two layers and the previous model (LSTM with one layer).

|   Model  | LSTM one layer | Bi-LSTM two layers |
|:--------:|:--------------:|:------------------:|
|   Loss   |     0.0152     |    **0.0050**      |
| Accuracy |     99.5758    |    **99.8550**     |

We can see similar results as the validation one for both the model. Also, we still see a little improvement of the accuracy and the loss for the larger model. But when considering that we only improved by around 0.3, one can
argue that it's only a matter of the seed. To test our approach's robustness, we could use retrain multiple times
our training step but using a different seed every time. Using those trained models, we can report the mean and one standard variation of the metrics instead of a single training. But instead of doing that, let's try something else. 

#### Zero Shot Evaluation
Since we have to our disposition other country address, let's see if our model has really learned a typical address sequence
or he has simply learned all the cases (know as memorization).

We will test three different cases

   - the first one we will test if our model performs well on countries using the exact same 
    address structure as our training dataset: United-States of America (US) and United-Kingdom (UK)
   - the second one we will test if our model performs well on a country using the exact same address structure **but** 
    using a totally different language: Russia (RU)
   - the last one will test if our model performs well on a country using a different address structure **and** a different language: Mexico (MX).

For each, we will have a total dataset of `100,000` examples, and we will use the last and best epoch results (the 10th). 
Also, we will use the same pre-processing steps (i.e. data vectorization, the same pad collate function), but we will only apply
a test phase.

But first, let's download and vectorize all the needed datasets.

```python
download_data('./data/', "us")
download_data('./data/', "gb")
download_data('./data/', "ru")
download_data('./data/', "mx")

us_data = pickle.load(open("./data/us.p", "rb"))  # 100,000 examples
gb_data = pickle.load(open("./data/gb.p", "rb"))  # 100,000 examples
ru_data = pickle.load(open("./data/ru.p", "rb"))  # 100,000 examples
mx_data = pickle.load(open("./data/mx.p", "rb"))  # 100,000 examples

dataset_vectorizer.vectorize(us_data)
dataset_vectorizer.vectorize(gb_data)
dataset_vectorizer.vectorize(ru_data)
dataset_vectorizer.vectorize(mx_data)
```

##### First Test

Now let's test for the United-States of America and United-Kingdom.

```python
us_loader = DataLoader(us_data, batch_size=batch_size, collate_fn=pad_collate_fn)
exp.test(us_loader)
exp_bi_lstm.test(us_loader)

gb_loader = DataLoader(gb_data, batch_size=batch_size, collate_fn=pad_collate_fn)
exp.test(gb_loader)
exp_bi_lstm.test(gb_loader)
```

The next table presents the results of both the model for both the country. We first see that we obtain
better results for the two countries using the BLSTM (around 8% better). It's interesting to see that even if the structure is similar. Also, the
presence of the same language as in the training dataset (i.e. English), we obtain poorer results than before. That situation
is mostly due to the postal code format is not similar. For the US, it is 5 digits, and for the UK it is similar to Canada, but it is not always a letter followed by a number, and it is not always 6 characters. It's *normal* for a model to
have difficulty is that kind of new pattern, but he has still achieved good results.

| Model (Country) | LSTM one layer | Bi-LSTM two layers |
|:---------------:|:--------------:|:------------------:|
|    Loss (US)    |     0.6176     |       **0.3078**   |
|  Accuracy (US)  |     84.7396    |       **91.8220**  |
|    Loss (UK)    |     0.4368     |       **0.1571**   |
|  Accuracy (UK)  |     86.2543    |       **95.6840**  |


##### The Second and Third Test

Now let's tests for Russia and Mexico.

```python
ru_loader = DataLoader(ru_data, batch_size=batch_size, collate_fn=pad_collate_fn)
exp.test(ru_loader)
exp_bi_lstm.test(ru_loader)

mx_loader = DataLoader(mx_data, batch_size=batch_size, collate_fn=pad_collate_fn)
exp.test(mx_loader)
exp_bi_lstm.test(mx_loader)
```

The next table presents the results of both the model for both the country tested. We first see that the first test 
(RU) gives poorer results than Mexico, even if the second one is a different structure and language. 
This situation could be explained by both languages' language roots; Spanish is closer to French than Russia. 
But an interesting thing is that even in a *difficult* annotation context, both the model perform relatively well. 
It means that our models seem to have really learned the *logic* of an address sequence. It could also mean that if 
we train our model longer, maybe we could improve our results. But, other improvements will be discussed in the next summary section.

| Model (Country) | LSTM one layer | Bi-LSTM two layers |
|:---------------:|:--------------:|:------------------:|
|    Loss (RU)    |   **2.5181**   |       4.6118       |
|  Accuracy (RU)  |   **48.9820**  |       47.3185      |
|    Loss (MX)    |     2.6786     |     **1.7147**     |
|  Accuracy (MX)  |     50.2013    |     **63.5317**    |

### Summary
In summary, we found that using a Bi-LSTM with two layers seems to perform better on countries' addresses not seen during training. Still, the results are not as good as those of Canada (training dataset). A solution to this problem could be to train a model using all the
possible data in the world. This approach was used by [Libpostal](https://github.com/openvenues/libpostal) which trained a 
CRF over an impressive near `100` million address (yes, **100 million**). The data is publicly available if you want to explore this avenue next.

We also explored that the language has a negative impact on the results since we use monolingual word embeddings (i.e. French), 
which is *normal* considering that they were trained for a specific language. A possible solution to that problem is the use of subword embedding composed of sub-division of a word instead of the complete one. For example, a two characters window embeddings of `H1A1` would be the aggregate embeddings of the subword `H1`, `1A` and `A1`. 

> Alert of self-promotion of my work here
I've personally explored this avenue in an article about using [subword embedding for address parsing](https://arxiv.org/abs/2006.16152).  

That being said, our model still performed well on the Canadian dataset, and one can simply train simpler LSTM model using
country data to obtain the best results possible with the simpler model as possible. 
