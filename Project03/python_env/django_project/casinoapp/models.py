from django.db import models
from django.contrib.auth.models import User

class PlayerManager(models.Manager):
	def create_player(self,username,password,points):
		user=User.objects.create_user(username,password)
		player=self.create(user=user,points=points)
		return player
class Player(models.Model):
	user=models.OneToOneField(User,on_delete=models.CASCADE,primary_key=True)
	points=models.IntegerField(default=5000)
	objects=PlayerManager()
