from django.urls import path
from . import views

urlpatterns = [
	       path('addUser/', views.addUser, name='userauthapp-addUser'),
	       path('loginUser/', views.login_user, name='userauthapp-login_user')
]
