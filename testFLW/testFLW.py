import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
pair = open('pair.txt', 'r').readlines()
pic1= []
num1 = []
pic2_num2 = []
num2 = []
for i in range(len(pair)):
    d = pair[i].split()
    if 0<len(d):
        pic1.append(d[0])
    else:
        pic1.append(None)
    if 1<len(d):
        num1.append(d[1])
    else:
        num1.append(None)
    if 2<len(d):
        pic2_num2.append(d[2])
    else:
        pic2_num2.append(None)   
    if 3<len(d):
        num2.append(d[3])
    else:
        num2.append(None)

import scipy.io as sio
LFW_Feature = sio.loadmat("/home/deepinsight/caffe-face/LFW_Feature.mat")

similarsame = []
similardiff = []
for i in range(2,len(pair)):
    str1 = ''
    str2 = ''
    if len(pic2_num2[i]) < 4:
        str1 = "%s_%04d.jpg" % (pic1[i], int(num1[i]))
        str2 = "%s_%04d.jpg" % (pic1[i], int(pic2_num2[i]))
    else:
        str1 = "%s_%04d.jpg" % (pic1[i], int(num1[i]))
        str2 = "%s_%04d.jpg" % (pic2_num2[i], int(num2[i]))
        
    import numpy as np    
    numnum1 = np.where(LFW_Feature['list']==str1)[0][0]
    numnum2 = np.where(LFW_Feature['list']==str2)[0][0]
    #import pdb;pdb.set_trace()
    norm1 = 1e-8 + np.sqrt((LFW_Feature['feature'][numnum1] ** 2).sum())
    norm2 = 1e-8 + np.sqrt((LFW_Feature['feature'][numnum2] ** 2).sum())
    similar = np.dot(LFW_Feature['feature'][numnum1],LFW_Feature['feature'][numnum2]) / norm1 / norm2
    
    if len(pic2_num2[i]) < 4:
        similarsame.append(similar)
    else:
        similardiff.append(similar)
        
plt.figure(1)
x = np.linspace(0, 3000, 3000)
plt.plot(x, similarsame)
plt.savefig("1.jpg")

plt.figure(2)
x = np.linspace(0, 3000, 3000)
plt.plot(x, similarsame)
plt.savefig("2.jpg")

ratioall = []

for threshold in np.arange(0.1, 1, 0.001):
    numpos = 0
    numneg = 0
    for i in range(len(similarsame)):
        if similarsame[i] >= threshold:
            numpos += 1
        else:
            numneg += 1
        if similardiff[i] < threshold:
            numpos += 1
        else:
            numneg += 1
    ratio = float(numpos) / (numpos + numneg)
    ratioall.append(ratio)


plt.figure(2)
x = np.linspace(0, 1, 1000)
plt.plot(x, ratioall)
plt.savefig("3.jpg")
