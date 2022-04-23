# OversamplingKNN
Experiments on [oversampling](https://en.wikipedia.org/wiki/Oversampling_and_undersampling_in_data_analysis) with [KNN classification model](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm)

**Language: R**

**Start: 2022**

## Why
I had an unbalanced dataset that I needed to use to build a binary classification model. Since it had unbalanced classes (i.e., one class was way more present than the other), I tried to use a random oversampling technique to improve the training of the model. The problem forced me to put together this R experiment to study the effect of oversampling on KNN models.

## Example

I created an unbalanced data frame with 16 points associated with two classes:

![Example](/images/plot1.jpg)

Understandably, the KNN model trained on such data (with k = 3) classifies the two points (class B, cross symbol) that are on the left side of the following image:

![Example](/images/plot2.jpg)

Here is the confusion matrix:

Reference   | Prediction A | Prediction B
------------|--------------|--------------
Reference A |      12      |      0
Reference B |       2      |      2

I applied random oversampling and retrained the KNN model:

![Example](/images/plot3.jpg)

The oversampling did improve the prediction of the underrepresented class (class B, cross symbol), but had a negative effect on the prediction of the class A points. This is understood, since the creation of random class B points affects the prediction of those class A points that are close to such class B points.
