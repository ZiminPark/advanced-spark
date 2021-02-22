#!/bin/sh

pip install sparknlp
pyspark --packages com.johnsnowlabs.nlp:spark-nlp_2.11:2.7.4
