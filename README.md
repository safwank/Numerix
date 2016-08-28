[![Build Status](https://travis-ci.org/safwank/Numerix.svg?branch=master)](https://travis-ci.org/safwank/Numerix)

# Numerix

A collection of useful mathematical functions in Elixir with a slant towards statistics, linear algebra and machine learning.

## Installation

Add `numerix` to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:numerix, "~> 0.1.0"}]
  end
```

Ensure `numerix` is started before your application:

```elixir
  def application do
    [applications: [:numerix]]
  end
```

## Examples

Check out the [tests](https://github.com/safwank/Numerix/tree/master/test) for examples.

## Documentation

Check out the [API reference](https://hexdocs.pm/numerix/api-reference.html) for the latest documentation.

## Features

### Statistics

* Mean
* Weighted mean
* Median
* Mode
* Range
* Variance
* Population variance
* Standard deviation
* Population standard deviation
* Moment
* Kurtosis
* Skewness
* Covariance
* Weighted covariance
* Population covariance
* Quantile
* Percentile

### Correlation functions

* Pearson
* Weighted Pearson

### Distance functions

* Pearson
* Minkowski
* Euclidean
* Manhattan
* Jaccard

### General math functions

* nth root

### Special functions

* Logit
* Logistic

### Window functions

* Gaussian

### Linear algebra

* Dot product
* L1-norm
* L2-norm
* p-norm
* Vector subtraction and multiplication

### Kernel functions

* RBF
