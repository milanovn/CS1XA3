# Generated by Django 2.2 on 2019-04-20 17:12

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('auth', '0011_update_proxy_permissions'),
        ('casinoapp', '0008_auto_20190420_1634'),
    ]

    operations = [
        migrations.CreateModel(
            name='Player',
            fields=[
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to=settings.AUTH_USER_MODEL)),
                ('points', models.IntegerField(default=5000)),
            ],
        ),
        migrations.DeleteModel(
            name='SomeData',
        ),
    ]
