import time
import networkx as nx
import numpy as np

no_tests = 1000
N = 1000
D = 2

store_times = np.zeros(no_tests)
# print(store_times)
for k in range(no_tests):
    start = time.time()
    p = 1
    R = np.random.random((N, D))
    G = nx.DiGraph()
    edge_list = []
    for i in range(N):
        G.add_node(i, position=tuple(R[i]))
        for j in range(N):
            if (R[i] > R[j]).all():
                if p == 1. or p > np.random.random():
                    edge_list.append([j,i])
    G.add_edges_from(edge_list)
    end = time.time()
    store_times[k] = (end - start)

print("the mean is ", np.mean(store_times), " while the standard deviation is ", np.std(store_times))