from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
import json

def addUser (request):
	jsonRequest = json.loads(request.body)
	given_username =  jsonRequest.get('username','')
	given_password =  jsonRequest.get('password','')

	if given_username!=''and given_password!='': #Add something to check if given combination already exists
		user=User.objects.create_user(username=given_username,password=given_password)
		return HttpResponse("Account successfully created")
	elif given_username=='':
		return HttpResponse("Please provide a username")
	elif given_password=='':
		return HttpResponse("Please provide a password")
def login (request):
	jsonRequest = json.loads(request.body)
	given_username    = jsonRequest.get('username','')
	given_password    = jsonRequest.get('password','')

	user = authenticate (request,username=given_username,password=given_password)
	if user is not None:
		login(request,user)
		return HttpResponse("Success!")
	else:
		return HttpResponse("Failed!")
