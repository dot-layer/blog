import gzip
import os
import shutil
import warnings

import requests


def download_from_url(model: str, saving_dir: str, extension: str):
    """
    Simple function to download the content of a file from a distant repository.
    """
    model_url = "https://graal.ift.ulaval.ca/public/deepparse/{}." + extension
    url = model_url.format(model)
    r = requests.get(url)

    os.makedirs(saving_dir, exist_ok=True)
    open(os.path.join(saving_dir, f"{model}.{extension}"), "wb").write(r.content)


def download_fasttext_magnitude_embeddings(saving_dir):
    """
    Function to download the magnitude pre-trained fastText model.
    """
    model = "fasttext"
    extension = "magnitude"
    file_name = os.path.join(saving_dir, f"{model}.{extension}")
    if not os.path.isfile(file_name):
        warnings.warn("The fastText pre-trained word embeddings will be download in magnitude format (2.3 GO), "
                      "this process will take several minutes.")
        extension = extension + ".gz"
        download_from_url(model=model, saving_dir=saving_dir, extension=extension)
        gz_file_name = file_name + ".gz"
        with gzip.open(os.path.join(saving_dir, gz_file_name), "rb") as f:
            with open(os.path.join(saving_dir, file_name), "wb") as f_out:
                shutil.copyfileobj(f, f_out)
        os.remove(os.path.join(saving_dir, gz_file_name))
    return file_name


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
