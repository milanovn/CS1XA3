from django.shortcuts import render
from django.http import HttpResponse

def authentication(request):
	name=request.POST.get("name","")
	password=request.POST.get("password","")
	#if name!="Jimmy" and password!="Hendrix":
	#	return (HttpResponse("Bad User Name"))
#	else:
#		return (HttpResponse("Cool"))
	return HttpResponse(name+password)
# Create your views here.
