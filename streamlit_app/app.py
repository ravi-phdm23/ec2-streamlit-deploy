import streamlit as st
import pandas as pd
import altair as alt

st.title("Sample Streamlit App on EC2")

df = pd.DataFrame({
    "x": range(10),
    "y": [i*i for i in range(10)]
})

chart = alt.Chart(df).mark_line().encode(x="x", y="y")
st.altair_chart(chart)
