[![Build Status](https://travis-ci.org/safwank/Numerix.svg?branch=master)](https://travis-ci.org/safwank/Numerix)

# Numerix

A collection of (potentially) useful mathematical functions. At the moment it has a number of distance and correlation functions. The plan is to implement other special functions, statistics, probability distributions, maybe even machine learning algorithms.

## Installation

Add `numerix` to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:numerix, "~> 0.0.6"}]
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
