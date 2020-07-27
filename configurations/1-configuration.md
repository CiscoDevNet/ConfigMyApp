---
sort: 1
---

# Configuring input parameters

ConfigMyApp accepts arguments from the following 3 (combined) sources:- runtime, environment variables and `config.json` file

The order of parameter precedence is as follows:-

 1. Runtime parameters
 2. Environment variables 
 3. Configuration file `config.json`

So in summary, runtime parameters have precedence over environment variables, and environment variables have precedence over configuration `JSON` file.

Note that mandatory parameters need to be provided in any (and not all) of the three configuration methods listed above for ConfigMyApp to be able to start.
