#import time

#start_time = time.time()#
#print("How many tries per second")
#attempts = input()
#print("For how many seconds?")
#run_time = input()#
#print("{} tries for {} seconds".format(attempts,run_time))#
#i = 0
#current_time = time.time()
#print(start_time)
#print(current_time)


#print("Press Ctrl-C to stop")
#try: 
#	while True:
#		print("lol")
#except KeyboardInterrupt:
#	print("fine then, keep your secrets")


import pycurl
import sys
import json
from io import BytesIO
import time


# Fill out URL when you have an ELB. 
# Coul also make this a passed in arg. If I have time.
URL = ""

fail_count = 0
ttlb_list = []
buffer = BytesIO()


def test_url():
	global fail_count
	fetch = pycurl.Curl()
	fetch.setopt(pycurl.URL, URL)
	fetch.setopt(pycurl.FOLLOWLOCATION, 1)
	fetch.setopt(pycurl.WRITEDATA, buffer) # this prevents output from being printed at end of program
	try:
		content = fetch.perform()
		TTLB = fetch.getinfo(pycurl.TOTAL_TIME)
		fetch.close()
		ttlb_list.append(TTLB)
	except KeyboardInterrupt:
		raise
	except:
		fail_count += 1

def indefinite_try():
	print("Ctrl-C to end")
	start_time = time.time()
	try:
		while True:
			test_url()
	except KeyboardInterrupt:
		print("Fine then, keep your secrets")
	end_time = time.time()

	return end_time - start_time


def main():
	total_time = indefinite_try()
	print("Attempted %i requests over %f seconds" 
		%((len(ttlb_list) + fail_count), total_time))
	print("Successful: %i\nAverage TTLB: %f\nFailures: %i" 
		%(len(ttlb_list), (sum(ttlb_list) / len(ttlb_list)), fail_count))


if __name__ == "__main__":    
    main()