from django import template

register = template.Library()

@register.filter(name='contains')
def contains(value, arg):
    return arg in value
