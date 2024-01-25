#%%
import time
import numpy as np
import h5py
import matplotlib.pyplot as plt
import scipy
from PIL import Image
from scipy import ndimage
from dnn_app_utils_v3 import *
from tqdm import tqdm
# from simul import *
initial_size=4

#%%
train_x_orig, train_y, test_x_orig, test_y, classes = load_data()
index = 25
# plt.imshow(train_x_orig[index])
# print ("y = " + str(train_y[0,index]) + ". It's a " + classes[train_y[0,index]].decode("utf-8") +  " picture.")

# print(train_x_orig)
# print(train_x_orig.shape)
train_x=train_x_orig.T
train_y=train_y.reshape((train_y.shape[0], 1))
# print("#############", train_y.shape)
train_y=train_y.T
# print(type(train_x_orig))
# print(train_y.shape)

# print(train_x_orig[2])

m_train = train_x_orig.shape[0]
# num_px = train_x_orig.shape[1]
print(train_y.shape)
# m_test = test_x_orig.shape[0]



n_x=4
n_h=7
n_y=1

layers_dims=(n_x, n_h, n_y)

def two_layer_model(X, Y, layers_dims, learning_rate = 0.0075, num_iterations = 3000, print_cost=False):
    grads={}
    costs=[]
    m=X.shape[1]
    n_x, n_h, n_y=layers_dims

    
    parameters=initialize_parameters(n_x, n_h, n_y)

    W1=parameters["W1"]
    W2=parameters["W2"]
    b1=parameters["b1"]
    b2=parameters["b2"]

    for i in range(num_iterations):
        A1, cache1= linear_activation_forward(X, W1, b1, "relu")
        A2, cache2= linear_activation_forward(A1, W2, b2, "sigmoid")

        cost=compute_cost(A2, Y)

        dA2= -(np.divide(Y,A2) - np.divide(1-Y,1-A2))

        dA1, dW2, db2= linear_activation_backward(dA2, cache2, "sigmoid")
        dA0, dW1, db1= linear_activation_backward(dA1, cache1, "relu")

        grads['dW1'] = dW1
        grads['db1'] = db1
        grads['dW2'] = dW2
        grads['db2'] = db2

        parameters= update_parameters(parameters, grads, learning_rate)

        W1 = parameters["W1"]
        b1 = parameters["b1"]
        W2 = parameters["W2"]
        b2 = parameters["b2"]

        if print_cost and i % 100 == 0:
            print("Cost after iteration {}: {}".format(i, np.squeeze(cost)))
        if print_cost and i % 100 == 0:
            costs.append(cost)

    plt.plot(np.squeeze(costs))
    plt.ylabel('cost')
    plt.xlabel('iterations (per hundreds)')
    plt.title("Learning rate =" + str(learning_rate))
    plt.show()

    return parameters

# parameters = two_layer_model(train_x, train_y, layers_dims = (n_x, n_h, n_y), num_iterations = 3000, print_cost=True)



#%%


layers_dims = [initial_size, 25, 7, 5, 1]

def L_layer_model(X, Y, layers_dims, learning_rate = 0.0075, num_iterations = 3000, print_cost=False):
    costs=[]
    grads={}
    parameters=initialize_parameters_deep(layers_dims)

    for i in tqdm(range(num_iterations)):

        AL, caches=L_model_forward(X, parameters)

        cost=compute_cost(AL, Y, i)
        
        grads=L_model_backward(AL, Y, caches)

        parameters=update_parameters(parameters, grads, learning_rate)

        if print_cost and i % 100 == 0:
            print ("Cost after iteration %i: %f" %(i, cost))
        if i % 100 == 0:
            costs.append(cost)

    plt.plot(np.squeeze(costs))
    plt.ylabel('cost')
    plt.xlabel('iterations (per hundreds)')
    plt.title("Learning rate =" + str(learning_rate))
    plt.show()
    
    return parameters

parameters = L_layer_model(train_x, train_y, layers_dims, learning_rate=0.0075, num_iterations = 2000, print_cost = True)


pred_train = predict(train_x, train_y, parameters)
# pred_test = predict(test_x, test_y, parameters)



# print_mislabeled_images(classes, test_x, test_y, pred_test)


# %%
