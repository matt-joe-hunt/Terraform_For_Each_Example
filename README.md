## Introduction

In this session, we will be exploring a simple use of the *for_each* meta argument.  The use case we will examine is creating a series of Cloudwatch alarms by reusing one module, passing in different parameters each time.  However, we also want to make our code easy to maintain and extend by putting these parameters into a list that we can easily manipulate.

## terraform.tfvars

It is in the *terraform.tfvars* file that we will define the parameters for our different alarms.  To achieve this we will be using a map of maps, not the easiest thing to get our heads around but after looking at one we should be able to reproduce it in the future. 

The first set of keys in this map is an arbitrary reference for each alarm that we want to create, whilst the value is another map.  It is this *inner* map that defines the attributes our alarm module will accept.

I've tried to keep the alarm straightforward, if you want to get more detail about the attributes that the *aws_cloudwatch_metric_alarm* resource takes, I suggest that you take a look at the official Terraform documentation.

## Alarm Module

It is in the *main.tf* file in this module that we are using the *for_each* meta-argument.  This argument takes in a map as a parameter and then allows us to refer to each value in that map by its key, in our case, this will allow us to refer to the maps that contain the attributes that we originally set out in our *terraform.tfvars* file.  We achieve this by passing our map into our resource as a variable.

We can refer to each of the keys in our map by using the *each.value* syntax, the *for_each* syntax creates a copy of the resource for each of the keys in the map, and as these values are another map, we can pull out a value from that map using the *each.value.<value>* syntax.

To see what the use of this meta-argument can achieve, run a *terraform plan* command in the project root to see that it will create 2 resources, 1 for each of the keys in the *alarm_list* variables.  Note that each of these resources has a reference that corresponds to the name of the keys in the map, and that the attributes for those resources are the values of the *inner* map.

In conclusion, it might take a bit of time to understand what exactly is going on here to implement it in your own projects, however, I hope the power is clear.  In this example we are creating only 2 resources from our variable, however, it would be very easy to extend this infrastructure by adding more keys to the *alarm_list* map, we would only need to make changes in this one location, easily allowing our infrastructure to be modified and improved.