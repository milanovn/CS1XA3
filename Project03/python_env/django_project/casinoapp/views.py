from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
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
def player_info(request):
	if not request.user.is_authenticated:
		return HttpResponse("Logged out")
	else:
			response={}
			response['username']=request.user.username
			user_id=request.user.id
			response['points']=Player.objects.filter(user_id=user_id).first().points
			response['error']="Success"
			return JsonResponse(response)
def points_info(request):
	if not request.user.is_authenticated:
		return HttpResponse("Logged out")
	else:
		user_id=request.user.id
		points=Player.objects.filter(user_id=user_id).first().points
		strPoints=str(points)
		return HttpResponse(strPoints)
def updatePoints(request):
	if not request.user.is_authenticated:
		return HttpResponse("Logged out")
	else:
		user_id=request.user.id
		body=request.POST
		user_points=int(body.get("points",""))
		if type(user_points)==int and user_points is not None:
			Player.objects.filter(user_id=user_id).update(points=user_points)
			return HttpResponse(body.get("points",""))
		else:
			return HttpResponse("Did not update ")
