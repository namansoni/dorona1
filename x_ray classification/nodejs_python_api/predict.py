import sys
import tensorflow.keras
from tensorflow.keras import *
from tensorflow.keras.models import model_from_json
from tensorflow.keras.preprocessing import image
import numpy as np

dest=sys.argv[1]
name=sys.argv[2]
sent_image_path=dest+name

json_file = open(r'Covid3.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
loaded_model =model_from_json(loaded_model_json)
loaded_model.load_weights(r'Covid3.h5')


img_pred1 = image.load_img(sent_image_path, target_size = (299, 299))
img_pred1 = image.img_to_array(img_pred1)
img_pred1 = np.expand_dims(img_pred1, axis = 0)
rslt1 = loaded_model.predict(img_pred1/255)

print(rslt1[0][0],rslt1[0][1],rslt1[0][2],end='')

sys.stdout.flush()