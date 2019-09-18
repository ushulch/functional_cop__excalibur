#! /usr/bin/env python3

import http.client
import json
import time

NUM_ITERATIONS = 1000


TRANSACTION_ID = 'b6df5836-a643-44c2-86ee-78e0113f5e80'

PUT_HOST = 'localhost'
PUT_PORT = 3000
PUT_BASE_PATH = '/transactions/'

FETCH_HOST = 'localhost'
FETCH_PORT = 3000
FETCH_BASE_PATH = '/transactions/'



def makeNewTransaction(amount):
    trans = {'id': TRANSACTION_ID,
             'date': '2019-03-12',
             'vendor': 'test',
             'amount': amount}

    return trans

def getTransaction(conn):
    conn.request('GET', FETCH_BASE_PATH + TRANSACTION_ID)
    resp = conn.getresponse()
    data = resp.read()
    return json.loads(data)


def putTransaction(conn, newTransaction):
    jsonTrans = json.dumps(newTransaction)
    conn.request('PUT', PUT_BASE_PATH + TRANSACTION_ID, jsonTrans)
    resp = conn.getresponse()
    resp.read()

def runTest(fetchConn, putConn, newAmount):
    newTrans = makeNewTransaction(newAmount)

    #putTransaction(putConn, newTrans)
    retrievedTrans = getTransaction(fetchConn)

    start = time.time()
    retAmount = retrievedTrans['amount']
    end = time.time()

    #if newAmount != retAmount:
    #    raise Exception('Amounts Differ', newAmount, retAmount)

    return (end - start)


def main():
    fetchConn = http.client.HTTPConnection(FETCH_HOST, port=FETCH_PORT)
    putConn = http.client.HTTPConnection(PUT_HOST, port=PUT_PORT)

    elapsedTime = 0
    for i in range(0,NUM_ITERATIONS):
        elapsedTime += runTest(fetchConn, putConn, i)

    averageElapsedTime = elapsedTime/NUM_ITERATIONS

    print('Average Elapsed Time: ' + str(averageElapsedTime))


main()
