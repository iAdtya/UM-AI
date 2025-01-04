from django.db import models

class UserProfile(models.Model):
    name = models.CharField(max_length=100)
    age = models.CharField(max_length=3)
    sex = models.CharField(max_length=20)
    location = models.CharField(max_length=100)
    education = models.CharField(max_length=100)
    professional_details = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class UserResponse(models.Model):
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    question = models.TextField()
    answer = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.name}'s response to {self.question[:30]}..."