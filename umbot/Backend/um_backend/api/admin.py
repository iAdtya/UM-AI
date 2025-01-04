from django.contrib import admin
from .models import UserProfile, UserResponse

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('name', 'age', 'location', 'created_at')
    search_fields = ('name', 'location')

@admin.register(UserResponse)
class UserResponseAdmin(admin.ModelAdmin):
    list_display = ('user', 'question', 'answer', 'created_at')
    list_filter = ('user', 'created_at')
    search_fields = ('user__name', 'question', 'answer')
