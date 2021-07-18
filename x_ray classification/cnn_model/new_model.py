from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D
from tensorflow.keras.layers import MaxPooling2D
from tensorflow.keras.layers import Flatten
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import Activation
from tensorflow.keras.layers import BatchNormalization
from tensorflow.keras.layers import Dropout
import matplotlib.image as mpimg
import numpy as np
import matplotlib.pyplot as plt
import cv2
from tensorflow.keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
from sklearn.metrics import classification_report, confusion_matrix
import matplotlib.pyplot as plt
import itertools 
import json


path = r'C:\Users\Pulkit\Desktop\COVID-19_Radiography_Dataset'


classes=["COVID", "Lung_Opacity", "Normal"]
num_classes = len(classes)
batch_size=16

train_datagen = ImageDataGenerator(rescale=1./255,
                                   rotation_range=0,
                                   width_shift_range=0.0,
                                   height_shift_range=0.0,
                                   horizontal_flip=False,
                                   validation_split=0.2)

val_datagen = ImageDataGenerator(rescale=1./255, validation_split=0.2)

train_gen = train_datagen.flow_from_directory(directory=path, 
                                              target_size=(299, 299),
                                              class_mode='categorical',
                                              subset='training',
                                              shuffle=True, classes=classes,
                                              batch_size=batch_size, 
                                              )
test_gen = val_datagen.flow_from_directory(directory=path, 
                                              target_size=(299, 299),
                                              class_mode='categorical',
                                              subset='validation',
                                              shuffle=False, classes=classes,
                                              batch_size=batch_size, 
                                              )


model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),activation='relu',input_shape=(299, 299, 3)))
model.add(BatchNormalization())

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size = (2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(BatchNormalization())

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size = (2, 2)))
model.add(Dropout(0.25))

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(BatchNormalization())

model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Flatten())

model.add(BatchNormalization())
model.add(Dense(128, activation='relu'))
model.add(Activation('relu'))
model.add(Dropout(0.25))


model.add(BatchNormalization())
model.add(Dense(num_classes, activation='softmax'))
opt = Adam(lr=0.005, beta_1=0.9, beta_2=0.999, epsilon=None, decay=0.01, amsgrad=False)
model.compile(optimizer=opt, loss='categorical_crossentropy', metrics=["accuracy"])
model.summary()


epoch=10

history = model.fit_generator(train_gen, steps_per_epoch=len(train_gen) // batch_size, validation_steps=len(test_gen) // batch_size, validation_data=test_gen, epochs=epoch, verbose=2)

import os
from tensorflow.keras.models import model_from_json

clssf = model.to_json()
with open("Covid3.json", "w") as json_file:
    json_file.write(clssf)
model.save_weights("Covid3.h5")
print("model saved")

img_pred = image.load_img(r'C:\Users\Pulkit\Desktop\COVID-19_Radiography_Dataset\Covid\Covid-12.png',target_size=(299, 299))
img_pred = image.img_to_array(img_pred)
img_pred = np.expand_dims(img_pred, axis = 0)
rslt = model.predict(img_pred)
print(rslt[0])
print(max(rslt[0]))
print(classes[(np.argmax(rslt, axis=1))[0]])



plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.title('Model accuracy')
plt.ylabel('Accuracy')
plt.xlabel('Epoch')
plt.legend(['Train', 'Val'], loc='upper left')
plt.show()

plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('Model loss')
plt.ylabel('Loss')
plt.xlabel('Epoch')
plt.legend(['Train', 'Val'], loc='upper left')
plt.show()

scores = model.evaluate_generator(test_gen, steps=len(test_gen))
print(scores)
print('Model accuracy: {}'.format(scores[1]))

scores = model.evaluate_generator(train_gen, steps=len(train_gen))
print(scores)
print('Model accuracy: {}'.format(scores[1]))




def plot_confusion_matrix(cm, classes, normalize=True, title='Confusion matrix', cmap=plt.cm.Blues):
    plt.figure(figsize=(10,10))
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        cm = np.around(cm, decimals=2)
        cm[np.isnan(cm)] = 0.0
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")
    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()



Y_pred = model.predict_generator(test_gen)

y_pred = np.argmax(Y_pred, axis=1)

print('Confusion Matrix model')

cm = confusion_matrix(test_gen.classes, y_pred)
plot_confusion_matrix(cm, classes, title='Confusion Matrix model')
plot_confusion_matrix(cm, classes,False, title='Confusion Matrix model')

with open('myfile.json', 'w') as file:
    json.dump(history.history, file)