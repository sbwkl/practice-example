#!/usr/bin/env python
# coding: utf-8


# from matplotlib import pyplot as plt
import sys
import cv2
import json
from IPython.core.debugger import set_trace

argv = sys.argv
if len(argv) < 2:
    raise ValueError('missing arguments')
path = argv[1]
image = cv2.imread(path)
height, width, channels = image.shape
image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # Converting BGR to RGB

canny = cv2.Canny(image, 300, 300)

contours, hierarchy = cv2.findContours(canny, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)
dx, dy = 0, 0
for i, contour in enumerate(contours):
    x, y, w, h = cv2.boundingRect(contour)
    if (w > 80) and (h > 80):
        dx = x
        dy = y
    cv2.rectangle(image, (x, y), (x + w, y + h), (0, 0, 255), 2)

ret = {
    'dx': dx,
    'dy': dy,
    'width': width,
    'height': height
}
print(json.dumps(ret))
