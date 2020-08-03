# que_hora_es - testapp

Small python script meant to check a URL until Ctrl-C is entered. 


Results will include:
* Total time spent running
* How many requests were made
* How many requests succeeded
* How many requests failed
* Average TTLB for successful requests

URL variable must be manually set to targeted URL. 

###Future Improvements

Things that could be improved
* Pass in URL as command-line variable
* Give option to run for X amount of minutes
* Give option to run X amount of requests per second/minute