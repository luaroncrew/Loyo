gnfd-cmd -c config.toml storage del-obj gnfd://loyo-application/transactions.csv
gnfd-cmd -c config.toml storage put --contentType "text/xml" --visibility private ./transactions.csv  gnfd://loyo-application/transactions.csv