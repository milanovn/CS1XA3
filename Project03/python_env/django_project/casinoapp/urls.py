from django.urls import path
from . import views

urlpatterns = [
	       path('addUser/', views.addUser, name='userauthapp-addUser')
]
