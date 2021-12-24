# Import required libraries
import dash
import math
import pandas as pd
from dash.dependencies import Input, Output, State, ClientsideFunction
import dash_core_components as dcc
import dash_html_components as html
import seaborn as sns
from scipy import stats
import scipy as sp
import plotly.express as px
import plotly.graph_objects as go
import numpy as np
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt

app = dash.Dash(__name__)

# Load data
heart_dat = pd.read_csv('source_data/heart.csv')

def tsne_processing(dat):

    dat_c =dat.copy()

    tsne = TSNE(n_components=2)
    X_tsne = tsne.fit_transform(dat_c)

    dat_c['tsne_x'] = X_tsne[:,0]
    dat_c['tsne_y'] = X_tsne[:,1]
    dat_c['subject_id'] = dat_c.index
    dat_c['size'] = np.zeros(len(dat_c.index)) + 0.5

    return dat_c

def pca_processing(dat):

    dat_c =dat.copy()

    pca = PCA(n_components=2)
    X_pca = pca.fit_transform(dat_c)

    dat_c['pca_x'] = X_pca[:,0]
    dat_c['pca_y'] = X_pca[:,1]
    dat_c['subject_id'] = dat_c.index
    dat_c['size'] = np.zeros(len(dat_c.index)) + 0.5

    return dat_c


# Create global chart template
mapbox_access_token = "pk.eyJ1IjoicGxvdGx5bWFwYm94IiwiYSI6ImNrOWJqb2F4djBnMjEzbG50amg0dnJieG4ifQ.Zme1-Uzoi75IaFbieBDl3A"



## Web page layout
app.layout = html.Div([
    html.H1("Heart Disease Visualization", style={'text-align':'center'}),


    html.Div([
        html.Div([
            html.H1("Features", style={'text-align':'Left'}),

            dcc.Dropdown(id='features',
                options=[
                    {"label": "all", "value":9999},
                    {"label": "age", "value":0},
                    {"label": "sex", "value":1},
                    {"label": "cp", "value":2},
                    {"label": "trestbps", "value":3},
                    {"label": "chol", "value":4},
                    {"label": "fbs", "value":5},
                    {"label": "restecg", "value":6},
                    {"label": "thalach", "value":7},
                    {"label": "exang", "value":8},
                    {"label": "oldpeak", "value":9},
                    {"label": "slope", "value":10},
                    {"label": "ca", "value":11},
                    {"label": "thal", "value":12},
                    ],
                    multi=True,
                    value=9999,
                    style={'width': "80%"}
                    ),


            html.H1("features", style={'text-align':'Left'}),
            ]),


            # html.Div(id='output_container', children=[]),

        html.Div([
            dcc.Graph(id='tsne', figure={}),
            ],
            className="tsne plot",
            style={"display": "inline-block"}
        ),

        html.Div([
            dcc.Graph(id='pca', figure={}),
            ],
            className="pca plot",
            style={"display": "inline-block"}
        )],
            className="pca and drop_downs",
            style={'width': '49%', "display": "inline-block"}
        ),
])


## Create graphs
## Plot t-SNE
@app.callback(
    Output(component_id='tsne', component_property='figure'),
    [Input(component_id='features', component_property='value')],
    )

def plot_main_graph(features):

    global _tSNE

    if (not isinstance(features, list)):
        features = [features]

        if not (9999 in features):
            heart_tsne = heart_tsne[features]

    heart_tsne = tsne_processing(heart_dat)

    x_min = np.min(heart_tsne["tsne_x"])
    x_max = np.max(heart_tsne["tsne_x"])
    y_min = np.min(heart_tsne["tsne_y"])
    y_max = np.max(heart_tsne["tsne_y"])

    _tSNE = px.scatter(heart_tsne, x="tsne_x", y="tsne_y", color='target',
                     hover_name="subject_id", title = 'TSNE For Heart Disease',
                     size = 'size',
                     hover_data=heart_tsne.columns,
                    color_discrete_sequence = px.colors.qualitative.Alphabet,
                    category_orders={'target':
                                     np.sort(heart_tsne['target'].unique()).tolist()})

    _tSNE.update_traces(marker_size=10)
    _tSNE.update_xaxes(range=[x_min-3, x_max+3])
    _tSNE.update_yaxes(range=[y_min-3, y_max+3])
    _tSNE = go.FigureWidget(_tSNE)


    # for i in range(0, len( _tSNE.data)):
    #     _tSNE.data[i].on_selection(tSNE_selection_fn)


    return _tSNE


@app.callback(
    Output(component_id='pca', component_property='figure'),
    [Input(component_id='features', component_property='value')],
    )

def plot_main_graph(features):

    global _PCA

    if (not isinstance(features, list)):
        features = [features]

        if not (9999 in features):
            heart_tsne = heart_tsne[features]

    heart_tsne = pca_processing(heart_dat)

    x_min = np.min(heart_tsne["pca_x"])
    x_max = np.max(heart_tsne["pca_x"])
    y_min = np.min(heart_tsne["pca_y"])
    y_max = np.max(heart_tsne["pca_y"])

    _PCA = px.scatter(heart_tsne, x="pca_x", y="pca_y", color='target',
                     hover_name="subject_id", title = 'PCA For Heart Disease',
                     hover_data=heart_tsne.columns,
                    color_discrete_sequence = px.colors.qualitative.Alphabet,
                    category_orders={'target':
                                     np.sort(heart_tsne['target'].unique()).tolist()})

    _PCA.update_traces(marker_size=10)
    _PCA.update_xaxes(range=[x_min-3, x_max+3])
    _PCA.update_yaxes(range=[y_min-3, y_max+3])
    _PCA = go.FigureWidget(_PCA)


    # for i in range(0, len( _tSNE.data)):
    #     _tSNE.data[i].on_selection(tSNE_selection_fn)


    return _PCA

if __name__ == '__main__':
    app.run_server(host='0.0.0.0', port=8725, debug=True)
