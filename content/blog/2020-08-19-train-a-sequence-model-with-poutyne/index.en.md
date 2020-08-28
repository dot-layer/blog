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

> Before starting this article, I would like to disclaim that this tutorial is greatly inspired of the one I did for Poutyne.
Also, the content is base on a recent article I wrote with Marouane Yassine. But, one can find difference between the 
two other content, I've try to put more insight for less technical reader than in the previous two.

Sequential data, such as address, are data that we assume are conditionnal to the preivously know information. For example, 
when writting an address, we know, in Canada, that after the civic number (e.g. 420) we have the street name (e.g. du Lac).
That means, that if we know the structure of the sequence, we can predict the next information in the sequence. Various 
modeling approach have been propose to make prediction over sequential data such as the Baye's Theorem (to valid), serie chorno (to valid), 
and more recently deep learning model know as Recurrent Neural Network (RNN) have been used along with sequential data.

But, training a RNN require various tricks (padding and packing) that we will explore in this article. First, lets 
state our problem and later on we will discuss what is an actual RNN or LSTM.

## Address Tagging
Address tagging is the task of detecting, by tagging, the different parts of an address such as the civic number, 
the street name  or the postal code (or zip code). The following figure shows an example of such a tagging.

![address parsing canada](address_parsing.png)

Since addresses are written in a predetermined sequence, RNN is the best way to crack this problem, but to decode the
output of the RNN (will be discuss later on), we also need another components, a fully-connected layer. 
So, our architecture, we will be compose of a RNN and a fully-connected layer. 

## RNN
Speaking of RNN, what is it ?

In biref, RNN are .... But, instead of using a vanilla RNN, we use a variant of it, know as a long short-term memory (LSTM) 
(to learn more about [LSTM](http://colah.github.io/posts/2015-08-Understanding-LSTMs/). 
For now, we use a single layer unidirectional LSTM. 

### Word Embeddings

Since our data is text, we will use a well-known word encoding techinque, word embeddings. Word embeddings are vector
representation of words. The main hypothesis is that word have linear relation along them. For example, the linear relation
between `king` and `queen` is the gender. So logically, if we remove the vector of `male` to `king` and add the vector
of `female` we should obtain the vector of `queen`. That been said, usually those kind of representation are in dimension `300`, which
make it impossible for humans to reason about, but the idea is there in a larger dimansion sapce.

So our LSTM input and hidden state dimensions will be of the same size as the word vectors. 
This size corresponds to the word embeddings dimension, which in our case will be the 
[French pre trained](https://fasttext.cc/docs/en/crawl-vectors.html) fastText embeddings of dimension `300`. 

### The Pytorch Model

But first, let's import all the needed packages.

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

So now, let's create a single (i.e. one layer) unidirectional LSTM wit `input_size` and `hidden_size` of `300`. We 
will explore later on the effect of stacking more layer and of using a bidirectionnal approache.

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
Since, the output of the LSTM network is of `300`, we will use a fully-connected layer to map this large dimension space into
a smaller one equal to the size of the tag space (e.g. number of tags to predict (8)). 

But, since we want to predict the most probable tokens, we will use the softmax function 
(see [here](https://en.wikipedia.org/wiki/Softmax_function) if softmax does not ring a bell).


```python
input_dim = dimension #the output of the LSTM
tag_dimension = 8

fully_connected_network = nn.Linear(input_dim, tag_dimension)
```

## Training Constants

Now, let's set our training constants. We first have the CUDA device used for training (using a CPU is way too long, 
if you don't have one, you can use a Google Colab notebook). 

Secondly, we set the batch size (i.e. the number of elements to see before updating the model), the learning rate for the optimizer
and the number of epochs.

```python
device = torch.device("cuda:0")

batch_size = 128
lr = 0.1

epoch_number = 10
```

Also, we need to set Pythons's, NumPy's and PyTorch's seeds by using Poutyne function so that our training is (almost) reproducible.

> See [here](https://determined.ai/blog/reproducibility-in-ml/) for more explanation why setting seed does not grand full reproductibility.

```python
set_seeds(42)
```

## The Dataset
The dataset consist of `1,010,987` complete French and English Canadian address and their associated address components tags.
Here an example `("420 rue des Lilas Ouest, Québec, G1V 2V3", [StreetNumber, StreetName, StreetName, StreetName, 
Orientation, City, PostalCode, PostalCode])`.

Now let's download our dataset; for simplicity, the data was already split into a 80-20 train, valid and a `100,000` test set. 
Also, the dataset is pickled for simplicity (using a Python `list`). Here is the code to download it.

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

If we take a look at the training dataset, as explain before, it's a list of `728,789` tuples where the first element 
is the full address, and the second element is a list of the tag (the ground truth).

```python
train_data[0:2]
```

> (the output)

![data_snapshot](data_snapshot.png)

### Vectorize the Dataset

Since we used word embeddings as our encoded representation of the word, we need to *convert* the address into 
word vector, for that we will use a vectorizer. This embedding vectorizer will be able to extract for every word the 
embedding value using the pre-trained French fastText model.

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

We also need to apply a similar approach but for the address tag (e.g. StreeNumber, StreetName). 
This vectorizer need to convert the tag into categorical values (e.g. 0, 1 ...). 

For simplicity, we will use a `DatasetVectorizer` class that will apply the vectorizing process using both 
the embedding and the address tag vectorizing process.

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

Now, lets vectorize (inplace) our dataset.

```python
dataset_vectorizer.vectorize(train_data)
dataset_vectorizer.vectorize(valid_data)
dataset_vectorizer.vectorize(test_data)
```

### DataLoader
> We use a first trick, ``padding``.

Now, since all the addresses are not of the same size, it is impossible to batch them together since all elements of a tensor must have the same lengths. But there is a trick, padding!

The idea is simple. We add *empty* tokens at the end of each sequence up to the longest one in a batch. For the word vectors, we add vectors of 0 as padding. For the tag indices, we pad with -100s. We do so because of the [cross-entropy loss](https://pytorch.org/docs/stable/generated/torch.nn.CrossEntropyLoss.html#torch.nn.CrossEntropyLoss), the accuracy metric and the [F1 metric](https://poutyne.org/metrics.html#poutyne.framework.metrics.FBeta) all ignore targets with values of -100.

To do this padding, we use the `collate_fn` argument of the [PyTorch `DataLoader`](https://pytorch.org/docs/stable/data.html#torch.utils.data.DataLoader), and on running time, that process will be done. One thing to take into account, since we pad the sequence, we need each sequence's lengths to unpad them in the forward pass. That way, we can pad and pack the sequence to minimize the training time (read [this good explanation](https://stackoverflow.com/questions/51030782/why-do-we-pack-the-sequences-in-pytorch) of why we pad and pack sequences).

```python
def pad_collate_fn(batch):
    """
    The collate_fn that can add padding to the sequences so all can have 
    the same length as the longest one.

    Args:
        batch (List[List, List]): The batch data, where the first element 
        of the tuple are the word idx and the second element are the target 
        label.

    Returns:
        A tuple (x, y). The element x is a tuple containing (1) a tensor of padded 
        word vectors and (2) their respective lengths of the sequences. The element 
        y is a tensor of padded tag indices. The word vectors are padded with vectors 
        of 0s and the tag indices are padded with -100s. Padding with -100 is done 
        because the cross-entropy loss, the accuracy metric and the F1 metric ignores 
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

So we have created an LSTM network (`lstm_network`), a fully connected network (`fully_connected_network`), those two 
components are used in the full network. This full network used padded, packed sequences (defined in the forward pass), 
so we created the `pad_collate_fn` function to process the needed work. The DataLoader will conduct that process. Finally, 
when we load the data, this will be done using the vectorizer, so the address will be represented using word embeddings. 
Also, the address components will be converted into categorical value (from 0 to 7).


## The Training

Now that we have all the components for the network let's define our Stochastic Gradient Descent 
([SGD](https://en.wikipedia.org/wiki/Stochastic_gradient_descent)) optimizer.

```python
optimizer = optim.SGD(full_network.parameters(), lr)
```

### Poutyne Experiment
> Disclaimer that I'm a dev on Poutyne so I will present code using this framework. See the project [here](https://poutyne.org/).

Lets create our experiment using Poutyne for automaticaly logging in the project root directory (`./`). We will also set
the loss function, the Cross entropy and the batch metrics, the accuracy, to monitor the training.

```python
exp = Experiment("./", full_network, device=cuda_device, optimizer=optimizer,
                 loss_function=cross_entropy, batch_metrics=["acc"])
```

Using our experiment, we can now launch the training as simple as

```python
exp.train(train_loader, valid_generator=valid_loader, epochs=epoch_number)
```
It will take around 5 minutes per epochs and about a minute for the validation so around an hour for the complete training.

### Results
The next figure present the loss and the accuracy during training (in blue) and during validation (in orange).
We obtain, after 10 epochs a validation loss and accuracy of `0.01981` and `99.54701` respectively, which is pretty
good for a first model. Also, we can see that our model did not seem to have overfitted.
![loss_acc](graph/training_graph.png)

## Bigger model

It's seem like our model performed pretty well, but just for fun let's unleash the full potential of LSTM using a
bidirectionnal approach (bi-LSTM). What it mean, is instead of _simply_ using a seeing the sequence from the start to the end, let's
also train the model to see the sequence from the end to the start, but it's important to state that the two direction are
not shared, that mean taht we _see_ the sequence in one direction at the time but we gather both the information for the 
fully connected layer. That way our model can get insight from both direction.

Also, instead of using only one layer, let's use a LSTM, which mean that we use two layers of hidden state.

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

full_network = FullNetWork(lstm_network, fully_connected_network)
```
 
### Training
 
 ```python
exp = Experiment("./", full_network, device=cuda_device, optimizer=optimizer,
                 loss_function=cross_entropy, batch_metrics=["acc"])
exp.train(train_loader, valid_generator=valid_loader, epochs=epoch_number)
```

### Results
Here a table of results diff.

TABLE

We can see, not much of a difference for a larger model, but now that we have our two models trained, let's validate as a
unique and final steps on the test set.

TABLE

| Model              | Loss   | Accuracy |
|--------------------|--------|----------|
| LSTM one layer     | 0.0152 | 99.5758  |
| Bi-LSTM two layers |        |          |

ANALYSE.

#### Zero Shot Evaluation
First US and GB with exact same structure (show picture)

RESULTS

Let's try with a different language but same structure (Russia)
RESULTS

Now, let's try a different language and a different structure (Mexico)
Results


