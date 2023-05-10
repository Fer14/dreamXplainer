# Libraries:
from fastapi import FastAPI, Query, Body
import uvicorn
import joblib, os
import pickle
import numpy as np
import pandas as pd
from typing import List, Dict
from pydantic import BaseModel
import datetime


# Global variables:
MODEL_PATH = '/apps/works/Ficheros_Datos/comunes/objetos_modelo/simple_model_iris.pickle'

# # Custom data type:
# class MyModel(BaseModel):
#     sepal_length : float 
#     sepal_width : float
#     petal_length : float
#     petal_width : float

# Load the model:
model_object = open(MODEL_PATH, "rb")
model = joblib.load(model_object)

# Initialize the app:
app = FastAPI(name = 'Machine Learning prediction service - experiment')


# Routes:
@app.get('/metadata/fecha_actual')
async def get_metadata():
    now = datetime.datetime.now()
    return {'fecha_actual':now.strftime("%Y-%m-%d %H:%M:%S")}


# ML model predictions:
@app.post("/predict")
async def predict(column_dict : Dict):
    
    pred_proba = model.predict_proba(np.array(list(column_dict.values())).reshape(1, -1))
    pred_class = np.argmax(pred_proba, axis = 1)
    
    return {"pred_class": float(pred_class[0]),
            "pred_prob": float(pred_proba[0][pred_class[0]])
            }


# Create the app:

if __name__ == '__main__':
    
    host = "10.99.191.249"
    port = 8080

    uvicorn.run(app, host = host, port = port)





