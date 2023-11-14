#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jan  8 22:55:59 2023
"""

# importing the required modules
#conda install seaborn

# Import the os module
import os

# Get the current working directory
cwd = os.getcwd()
# set path
path = "//Users/..."
os.chdir(path)

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt 
import xlrd

# specifying the path to excel file
data = pd.read_excel("SP Industry Country 2015 2019 Excel.xlsx")


SP = pd.read_excel("SoftPower Data Graph.xlsx")
SP = SP.drop_duplicates(subset=['Soft_Power30'])
SP = SP[:-1]
SP = SP.reset_index(drop=True)


# BOXPLOT UK Soft Power SP
sns.set(style="darkgrid")
plt.figure(figsize=(12,6))
b=sns.boxplot(x='Country',y='Soft_Power30',data=SP, palette='Spectral')
plt.title("Boxplot: Soft Power between Countries", fontsize= '20')
b.set_xlabel("Countries",fontsize=15)
b.set_ylabel("Soft Power Index",fontsize=15)
b.tick_params(labelsize=15)


# PLOT Export UK; 
data_groub = data[["Country", "Year", "Export_UK", "Employment","Turnover", "Industry"]]
data_expgrb = data_groub.groupby(['Country', 'Year']).sum()

plt.figure(figsize=(12,6))
gfg = sns.lineplot(x="Year", y="Export_UK",
             hue="Country",linewidth=4,
             data=data_expgrb)
plt.title("UK Exports by Country", fontsize= '20')
# for legend text
plt.setp(gfg.get_legend().get_texts(), fontsize='15') 
gfg.set_xlabel("Years",fontsize=15)
gfg.set_ylabel("Exports UK (in million £)",fontsize=15)
gfg.tick_params(labelsize=15)
# for legend title
plt.setp(gfg.get_legend().get_title(), fontsize='15') 
plt.show()













