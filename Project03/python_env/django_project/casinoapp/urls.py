from django.urls import path
from . import views

urlpatterns = [
	       path('addUser/', views.addUser, name='userauthapp-addUser'),
	       path('loginUser/', views.login_user, name='userauthapp-login_user'),
	       path('requestPoints/',views.player_info,name='userauthapp-requestPoints'),
	       path('roulettePoints/',views.points_info,name='userauthapp-roulettePoints'),
	       path('updatePoints/',views.updatePoints,name='userauthapp-roulettePoints'),
	       path('logout/',views.logout_view,name='userauthapp-logout')
]
