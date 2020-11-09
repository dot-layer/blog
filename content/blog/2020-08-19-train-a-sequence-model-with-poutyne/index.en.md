---
title: Train a Recurrent Neural Network (RNN) with Poutyne
author: David Beauchemin et Marouane Yassine
date: '2020-08-18'
slug: machine learning
type: post
categories: ["python", "machine learning"]
tags: []
description: "Address tagging with a RNN"
featured: "we-mastered-the-art-of-programming-cover.jpeg"
featuredpath: "img/headers/"
---

> In this article, we will train an RNN, or more precisely, an LSTM, to predict the sequence of tags associated with a 
given address, known as address parsing.

> Also, the article is available in a [Google Colab Jupyter notebook](https://colab.research.google.com/github/dot-layer/blog/blob/post%2Fdb_sequence_training_poutyne/content/blog/2020-08-19-train-a-sequence-model-with-poutyne/article_notebook.ipynb).

> Before starting this article, we would like to disclaim that this tutorial is greatly inspired by an online tutorial David created for the Poutyne framework. Also, the content is based on a recent article we wrote about address tagging. However, there are differences between the present work and the two others, we've tried to put more insights for the less technical reader in this one.


Sequential data, such as addresses, are pieces of information that are deliberately given in a specific order. In other words, they are sequences with a particular structure; and knowing this structure is crucial for predicting the missing entries of a given truncated sequence. For example, 
when writing an address, we know, in Canada, that after the civic number (e.g. 420), we have the street name (e.g. du Lac).
Hence, if one is asked to complete an address containing only a number, he can reasonably assume that the next information that should be added to the sequence is a street name. Various modelling approaches have been proposed to make predictions over sequential data. Still, more recently, deep learning models known as Recurrent Neural Network (RNN) have been introduced for this type of data.

The main purpose of this article is to introduce the various tricks (e.g., padding and packing) that are required for training an RNN. Before we do that, let us define our "address" problem more formally and elaborate on what RNNs (and LSTMs) actually are.

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
([for more about RNN](https://stanford.edu/~shervine/teaching/cs-230/cheatsheet-recurrent-neural-networks)). 

For the present purpose, we do not use the vanilla RNN, but a variant of it known as long short-term memory (LSTM) network. This latter, which involves components called gates, is often preferred over its competitors due to its better stability with respect to gradient update (vanishing and exploding gradient)
([to learn more about LSTMs](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)). 

For now, let's simply use a single layer unidirectional LSTM. We will, later on, explore the use of more layers and a bidirectional approach. 

### Word Embeddings

Since our data is text, we will use a well-known text encoding technique, word embeddings. Word embeddings are vector
representations of words. The main hypothesis underlying their use is that there exists a linear relation between words. For example, the linear relation
between the word `king` and `queen` is gender. So logically, if we remove the vector corresponding to `male` to the one for `king`, and then add the vector for
`female`, we should obtain the vector corresponding to `queen` (`king - male + female = queen`). That being said, those kinds of representation usually are in  high dimensions such as `300`, which
makes it impossible for humans to reason about them. Still, the idea is there but in a higher dimensional space.

So our LSTM's input and hidden state dimensions will be of the same sizes as the vectors of embedded words. 
For the present purpose, we will use the
[French pre trained](https://fasttext.cc/docs/en/crawl-vectors.html) fastText embeddings of dimension `300`. 

### The Pytorch Model

Let us first import all the necessary packages.

```python
%pip install --upgrade poutyne #install poutyne on colab
%pip install --upgrade colorama #install colorama on colab
%matplotlib inline

import contextlib
import os
import pickle
import re
import sys
from io import TextIOBase

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

Now, let's set our training constants. We first specify a CUDA (GPU) device for training (using a CPU takes way too long, 
if you don't have one, you can use the Google Colab notebook). 

Second, we set the batch size (i.e. the number of elements to see before updating the model), the learning rate for the optimizer
and the number of epochs.

```python
device = torch.device("cuda:0")

batch_size = 128
lr = 0.1

epoch_number = 10
```

We also need to set Pythons's, NumPy's and PyTorch's seeds using the Poutyne function so that our training is (almost) reproducible.

> See [here](https://determined.ai/blog/reproducibility-in-ml/) for more explanation of why setting seed does not guarantee complete reproducibility.

```python
set_seeds(42)
```

## The Dataset
The dataset consists of `1,010,987` complete French and English Canadian addresses and their associated tags.
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

Now let's load the data in memory.

```python
# load the data

train_data = pickle.load(open("./data/train.p", "rb"))  # 728,789 examples
valid_data = pickle.load(open("./data/valid.p", "rb"))  # 182,198 examples
test_data = pickle.load(open("./data/test.p", "rb"))  # 100,000 examples
```

As we explained before, the (train) dataset is a list of `728,789` tuples where the first element is the full address, and the second is a list of tags (the ground truth).

```python
train_data[0:2]
```

> (the output)

![data_snapshot](data_snapshot.png)

### Vectorize the Dataset

Since we used word embeddings as the encoded representations of the addresses, we need to *convert* the addresses into word vectors. In order to do that, we will use a `vectorizer` (i.e. the process of converting words into vectors). This embedding vectorizer will extract, for each word, the embedding value based on the pre-trained French fastText model.

> It takes some time to download the first time
```python
# We use this class so that the download templating of the fastText
# script be not buggy as hell in notebooks.
class LookForProgress(TextIOBase):
    def __init__(self, stdout):
        self.stdout = stdout
        self.regex = re.compile(r'([0-9]+(\.[0-9]+)?%)', re.IGNORECASE)
        
    def write(self, o):
        res = self.regex.findall(o)
        if len(res) != 0:
            print(f"\r{res[-1][0]}", end='', file=self.stdout)

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
This time, however, the `vectorizer` needs to convert the tags into categorical values (e.g. StreetNumber -> 0). 
For simplicity, we will use a `DatasetVectorizer` class that will apply the vectorizing process using both 
the embedding and the address vectorization process that we've just described.

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

```python
train_data[0]
```

> Here is a example after the vectorizing process

```
([array([ 5.30934185e-02, -6.72420338e-02,  8.96735638e-02, -3.26771051e-01,
         -4.42410737e-01, -1.32014668e-02,  1.50324404e-01, -2.50251926e-02,
          1.24011010e-01, -1.68488681e-01,  4.80616689e-02, -5.40233105e-02,
          1.21191796e-02,  3.89859192e-02,  1.25505164e-01, -1.40419468e-01,
         -2.62053646e-02,  1.01731330e-01, 
         ...
         -5.71550950e-02, -3.92134525e-02,  4.85491045e-02,  4.82993454e-01,
          3.35614271e-02, -5.97143888e-01, -9.82549414e-02,  8.23293403e-02],
        dtype=float32), #dimension of 300 # first word
        ... 
        # word N of the sequence
        array([-6.28125593e-02, -1.72182580e-03,  1.27990674e-02,  7.47001171e-02,
        ...
        3.74843590e-02],
        dtype=float32)],
    
 #second element of the tuple
 [0, 1, 1, 1, 3, 4, 5, 5] #the ground truth tag)
```

### DataLoader
> We use a first trick, ``padding``.

Now, because the addresses are not all of the same size, it is impossible to batch them together; recall that all tensor elements must have the same lengths. But there is a trick, padding!

The idea is simple; we add *empty* tokens at the end of each sequence until they reach the length of the longest one in the batch. For example, if we have three sequences of length ${1, 3, 5}$, padding will add *empty* tokens to the first two, 4 for the first and 2 for the second.

For the word vectors, we add vectors of 0 as padding. For the tag indices, we pad with -100's. We do so because the [cross-entropy loss](https://pytorch.org/docs/stable/generated/torch.nn.CrossEntropyLoss.html#torch.nn.CrossEntropyLoss) and the accuracy metric both ignore targets with values of -100.

To do the padding, we use the `collate_fn` argument of the [PyTorch `DataLoader`](https://pytorch.org/docs/stable/data.html#torch.utils.data.DataLoader), and on running time, the process will be done by the `DataLoader`. One thing to keep in mind when treating padded sequences is that their (original) length will be required to unpack them later on (since we also pack them), in the forward pass. That way, we can pad and pack the sequence to minimize the training time (read [this good explanation](https://stackoverflow.com/questions/51030782/why-do-we-pack-the-sequences-in-pytorch) of why we pack sequences).

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

Since our sequences are of variable lengths and that we want to be as efficient as possible when packing them, we cannot use the [PyTorch `nn.Sequential`](https://pytorch.org/docs/stable/generated/torch.nn.Sequential.html) class to define our model. Instead, we define the forward pass so that it uses packed sequences (again, you can read [this good explanation](https://stackoverflow.com/questions/51030782/why-do-we-pack-the-sequences-in-pytorch) of why we pack sequences).

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

We have created an LSTM network (`lstm_network`) and a fully connected network (`fully_connected_network`), and we use both
components in the full network. The full network makes use of padded-packed sequences, 
so we created the `pad_collate_fn` function to process the necessary work within the `DataLoader`. Finally, 
we will load the data using the vectorizer (within the `DataLoader` using the `pad_collate` function). This means that the addresses will be represented by word embeddings. 
Also, the address components will be converted into categorical value (from 0 to 7).


## The Training

Now that we have all the components for the network, let's define our optimizer (Stochastic Gradient Descent) 
([SGD](https://en.wikipedia.org/wiki/Stochastic_gradient_descent)).

```python
optimizer = optim.SGD(full_network.parameters(), lr)
```

### Poutyne Experiment
> Disclaimer that David is a dev on Poutyne, so we will present code using this framework. See the project [here](https://poutyne.org/).

Let's create our experiment using Poutyne for automatically logging in the project root directory (`./`). We will also set
the loss function and a batch metric (accuracy) to monitor the training.

```python
exp = Experiment("./", full_network, device=cuda_device, optimizer=optimizer,
                 loss_function=cross_entropy, batch_metrics=["acc"])
```

Using our experiment, we can now launch the training as simply as

```python
exp.train(train_loader, valid_generator=valid_loader, epochs=epoch_number)
```
It will take around 6 minutes per epochs, so around an hour for the complete training.

### Results
The next figure shows the loss and the accuracy during our training (blue) and during our validation (orange) steps.
After 10 epochs, we obtain a validation loss and accuracy of `0.01981` and `99.54701` respectively, which is pretty
good for a first model. Also, we can see that our model did not seem to have overfitted.

![loss_acc](graph/training_graph.png)

## Bigger model

It seems that our model performed pretty well, but just for fun, let's unleash the full potential of LSTM using a
bidirectional approach (bidirectional LSTM). What it means is that instead of _simply_ viewing the sequence from the start to the end, we
also train the model to see the sequence from the end to the start. It's important to state that the two directions are
not shared, meaning that we _see_ the sequence in one direction at the time, but we gather the information from both directions into the 
fully connected layer. That way, our model can get insight from both directions.

Instead of using only one layer, let's use a bidirectional bi-LSTM, which means that we use two layers of hidden state for each direction.

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
Here are our validation results for the last epoch of the larger model. On the validation dataset,
we can see that we obtain a marginal gain of around `0.3` for the accuracy over the previous one. Not much of an improvement.

|   Model  | Bidirectional bi-LSTM |
|:--------:|:------------------:|
|   Loss   |    0.0050          |
| Accuracy |    99.8594         |

But now that we have our two trained models, let's use the test set as a final and **unique** step for evaluating their performance.

```python
exp.test(test_loader)
exp_bi_lstm.test(test_loader)
```

The next table presents the results of the bidirectional bi-LSTM with two layers and the previous model (LSTM with one layer).

|   Model  | LSTM one layer | Bidirectional bi-LSTM |
|:--------:|:--------------:|:------------------:|
|   Loss   |     0.0152     |    **0.0050**      |
| Accuracy |     99.5758    |    **99.8550**     |

We see similar validation results for both models. Also, we still see a little improvement in accuracy and total loss for the larger model. Considering that we only improved by around 0.3, one can
argue that it's only a matter of seed. To test the robustness of our approach, we could train our model multiple times
using different seeds and report the mean and standard deviation of each metric over all experiments rather than the result of a single training. Let's try something else. 

### Zero Shot Evaluation
Since we have at our disposition addresses from other countries, let's see if our model has really learned a typical address sequence
or if it has simply *memorized* all the training examples.

We will test our model on three different types of dataset

   - first, on addresses with the exact same structure 
    as in our training dataset: addresses from the United States of America (US) and the United Kingdom (UK)
   - secondly, on addresses with the exact same structure as those in our training dataset **but** 
    written in a totally different language: addresses from Russia (RU)
   - finally, on addresses that exhibit a different structure **and** that are written in a different language: addresses from Mexico (MX).

For each test, we will use a dataset of `100,000` examples in total, and we will evaluate using the best epoch of our two models (i.e. last epoch for both of them). 
Also, we will use the same pre-processing steps as before (i.e. data vectorization, the same pad collate function), but we will only apply
a test phase, meaning no training step.

First, let's download and vectorize all the needed datasets.

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

Now let's test for the United States of America and United Kingdom.

```python
us_loader = DataLoader(us_data, batch_size=batch_size, collate_fn=pad_collate_fn)
exp.test(us_loader)
exp_bi_lstm.test(us_loader)

gb_loader = DataLoader(gb_data, batch_size=batch_size, collate_fn=pad_collate_fn)
exp.test(gb_loader)
exp_bi_lstm.test(gb_loader)
```

The next table presents the results of both models for both countries. We obtain
better results for the two countries using the bidirectional bi-LSTM (around 8% better). It's interesting to see that considering that their structures are similar to those in the training dataset (Canada), we obtain near as good results as those observed during training. Meaning that our model seems to have learned to recognize the structure of an address. Also, the
presence of the same language as in the training dataset (i.e. English), we obtain poorer results than before. That situation
is mostly due to the fact that the postal code formats are not the same. For the US, it is 5 digits, and for the UK it is similar to that of Canada, but it is not always a letter followed by a number, and it is not always 6 characters. It's *normal* for a model to
have difficulty when faced with new patterns. All in all, we can say that our model has achieved good results.

| Model (Country) | LSTM one layer | Bidirectional bi-LSTM |
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

The next table presents the results of both models for the two countries tested. We see that the first test 
(RU) gives poorer results than those for Mexican addresses, even if these latter are written in a different structure and language. 
This situation could be explained by both languages' roots; Spanish is closer to French than Russian is. 
An interesting thing is that even in a *difficult* annotation context, both models perform relatively well. 
It suggests that our models have really learned the *logic* of an address sequence. It could also mean that if 
we train our model longer, we could potentially improve our results. Other modifications that could improve our models are discussed in the next and final section.

| Model (Country) | LSTM one layer | Bidirectional bi-LSTM |
|:---------------:|:--------------:|:------------------:|
|    Loss (RU)    |   **2.5181**   |       4.6118       |
|  Accuracy (RU)  |   **48.9820**  |       47.3185      |
|    Loss (MX)    |     2.6786     |     **1.7147**     |
|  Accuracy (MX)  |     50.2013    |     **63.5317**    |

### Summary
In summary, we found that using a bidirectional bi-LSTM seems to perform better on addresses not seen during training, including those coming from other countries. Still, the results for addresses from other countries are not as good as those for Canadian addresses (training dataset). A solution to this problem could be to train a model using all the
data from all over the world. This approach was used by [Libpostal](https://github.com/openvenues/libpostal), which trained a 
CRF over an impressive near `100` million addresses (yes, **100 million**). If you want to explore this avenue, the data is publicly available.

We also explored the idea that the language has a negative impact on the results, since we use monolingual word embeddings (i.e. French), 
which is *normal* considering that they were trained for a specific language. A possible solution to that problem is the use of subword embedding composed of sub-division of a word instead of the complete one. For example, a two characters window embeddings of `H1A1` would be the aggregate embeddings of the subword `H1`, `1A` and `A1`. 

> Alert of self-promotion of our work here
We've personally explored this avenue in an article using [subword embedding for address parsing](https://arxiv.org/abs/2006.16152).  

That being said, our model still performed well on the Canadian dataset, and one can simply train simpler LSTM model using
country data to obtain the best results possible with a model as simple as possible. 
