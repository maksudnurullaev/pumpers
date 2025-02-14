# Shoot off 300 requests at the server, with a concurrency level of 10, to test the number of requests it can handle per second

# -p POST
# -H Authentication headers
# -T Content-Type
# -c Concurrent clients
# -n Number of requests to run
# -l Accept variable document length
# -k Connection keep-alive
# -v Verbosity level

ab -p test.json -T application/json -H 'Accept: application/json' -H 'Authorization: Basic SoMEtoKEN==' -H "Cookie: My_Session=AnOTheRTOken" -c 10 -n 300 -l -k -v 2 http://localhost:4000/456/transactions > transaction_post_results.txt 
