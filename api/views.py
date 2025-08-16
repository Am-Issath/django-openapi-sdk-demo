
from django.contrib.auth import get_user_model
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from .serializers import UserSerializer

User = get_user_model()

@api_view(["GET"])
@permission_classes([IsAuthenticatedOrReadOnly])
def users_list(request):
    qs = User.objects.all().order_by("id")[:50]
    data = UserSerializer(qs, many=True).data
    return Response(data)
