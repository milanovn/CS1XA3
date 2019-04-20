from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
import json
from .models import Player
def addUser (request):
	jsonRequest = json.loads(request.body)
	given_username =  jsonRequest.get('username','')
	given_password =  jsonRequest.get('password','')

	if given_username!=''and given_password!='': #Add something to check if given combination already exists
	#	user=User.objects.create_user(username=given_username,password=given_password) #Default points value is 5000
		player=Player.objects.create_player(username=given_username,password=given_password,points=5000)
		return HttpResponse("Account successfully created")
	elif given_username=='':
		return HttpResponse("Please provide a username")
	elif given_password=='':
		return HttpResponse("Please provide a password")
def login_user(request):
	jsonRequest = json.loads(request.body)
	given_username    = jsonRequest.get('username','')
	given_password    = jsonRequest.get('password','')

	if given_username!='' and given_password!='':

		user = authenticate(request,username=given_username,password=given_password)
		if user is not None:
			login(request,user)
			return HttpResponse("Success")
		else:
		#	return HttpResponse("given_username ++ given_password")
			return HttpResponse("Authentication Failed")
	else:
		return HttpResponse("Invalid login")
