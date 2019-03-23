from django.urls import path
from . import views

urlpatterns = [
    path('lab7/',views.authentication, name='lab07.authentication'),
]
