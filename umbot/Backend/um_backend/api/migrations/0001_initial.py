# Generated by Django 5.1.4 on 2025-01-03 23:01

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="UserProfile",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=100)),
                ("age", models.CharField(max_length=3)),
                ("sex", models.CharField(max_length=20)),
                ("location", models.CharField(max_length=100)),
                ("education", models.CharField(max_length=100)),
                ("professional_details", models.TextField()),
                ("created_at", models.DateTimeField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name="UserResponse",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("question", models.TextField()),
                ("answer", models.TextField()),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="api.userprofile",
                    ),
                ),
            ],
        ),
    ]
