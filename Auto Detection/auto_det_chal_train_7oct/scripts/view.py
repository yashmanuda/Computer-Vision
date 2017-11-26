

# Author : Girish Varma

import json
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from PIL import Image
import numpy as np

bbs = json.loads(open('../bbs/bbs.json').read())

l = len(bbs)


import random 
f = open('boxes.txt','w')
while True:
    i = random.randrange(l)
    im = np.array(Image.open('../images/'+ str(i) + '.jpg'), dtype=np.uint8)
    fig, ax = plt.subplots(1,figsize=(20, 20))
    ax.imshow(im)
    boxes = bbs[i]
    # print i, len(boxes)
    for j in range(len(boxes)):
        x, y = boxes[j][0]
        h = boxes[j][-1][1] - y  
        w = boxes[j][1][0] - x 
        print x,y, h, w
        # print boxes[j]
        rect = patches.Rectangle((x,y), w, h, linewidth=5, edgecolor='r', facecolor='none')
        ax.add_patch(rect)
    plt.show()
        



