import time
'''
      ___           ___           ___           ___           ___           ___     
     /\  \         /\__\         /\  \         /\__\         /\  \         /\__\    
    /::\  \       /:/  /        /::\  \       /:/  /        /::\  \       /::|  |   
   /:/\:\  \     /:/  /        /:/\:\  \     /:/__/        /:/\:\  \     /:|:|  |   
  /::\~\:\  \   /:/  /  ___   /:/  \:\  \   /::\__\____   /::\~\:\  \   /:/|:|  |__ 
 /:/\:\ \:\__\ /:/__/  /\__\ /:/__/ \:\__\ /:/\:::::\__\ /:/\:\ \:\__\ /:/ |:| /\__\
 \/__\:\ \/__/ \:\  \ /:/  / \:\  \  \/__/ \/_|:|~~|~    \:\~\:\ \/__/ \/__|:|/:/  /
      \:\__\    \:\  /:/  /   \:\  \          |:|  |      \:\ \:\__\       |:/:/  / 
       \/__/     \:\/:/  /     \:\  \         |:|  |       \:\ \/__/       |::/  /  
                  \::/  /       \:\__\        |:|  |        \:\__\         /:/  /   
                   \/__/         \/__/         \|__|         \/__/         \/__/    
      ___           ___           ___           ___           ___           ___     
     /\__\         /\  \         /\__\         /\__\         /\  \         |\__\    
    /::|  |       /::\  \       /::|  |       /:/  /        /::\  \        |:|  |   
   /:|:|  |      /:/\:\  \     /:|:|  |      /:/__/        /:/\:\  \       |:|  |   
  /:/|:|__|__   /:/  \:\  \   /:/|:|  |__   /::\__\____   /::\~\:\  \      |:|__|__ 
 /:/ |::::\__\ /:/__/ \:\__\ /:/ |:| /\__\ /:/\:::::\__\ /:/\:\ \:\__\     /::::\__\
 \/__/~~/:/  / \:\  \ /:/  / \/__|:|/:/  / \/_|:|~~|~    \:\~\:\ \/__/    /:/~~/~   
       /:/  /   \:\  /:/  /      |:/:/  /     |:|  |      \:\ \:\__\     /:/  /     
      /:/  /     \:\/:/  /       |::/  /      |:|  |       \:\ \/__/     \/__/      
     /:/  /       \::/  /        /:/  /       |:|  |        \:\__\                  
     \/__/         \/__/         \/__/         \|__|         \/__/                            
'''

print("please enter your map name(in DMM with ext-on):\n")
file = input()
f = open(file, "r+")

level_1 = ["turf", "obj", "area", "mob"]

'''
      ___           ___           ___           ___           ___     
     /\  \         /\__\         /\  \         /\  \         /\  \    
     \:\  \       /:/  /        /::\  \       /::\  \       /::\  \   
      \:\  \     /:/  /        /:/\:\  \     /:/\:\  \     /:/\ \  \  
      /::\  \   /:/  /  ___   /::\~\:\  \   /::\~\:\  \   _\:\~\ \  \ 
     /:/\:\__\ /:/__/  /\__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /\ \:\ \ \__\
    /:/  \/__/ \:\  \ /:/  / \/_|::\/:/  / \/__\:\ \/__/ \:\ \:\ \/__/
   /:/  /       \:\  /:/  /     |:|::/  /       \:\__\    \:\ \:\__\  
   \/__/         \:\/:/  /      |:|\/__/         \/__/     \:\/:/  /  
                  \::/  /       |:|  |                      \::/  /   
                   \/__/         \|__|                       \/__/    
'''
               
level_3_turf = ["floor", "wall"]
level_4_turf = ["plating", "window"]

def return_isoturf(stroke):
	for turf_unit in level_3_turf:
		if stroke.find(turf_unit) != -1:
			if turf_unit == "wall":
				if stroke.find("window") != -1:
					print(stroke)
					return "/turf/simulated/wall/newicon/window"
				else:
					return "/turf/simulated/wall/newicon"
			else:
				for turf_unit3 in level_4_turf:
					if stroke.find(turf_unit3) != -1:
						return "/turf/simulated/floor/plating"
					else:
						return "/turf/simulated/floor"
	return ""
				
	
'''
      ___           ___            ___         ___           ___           ___           ___     
     /\  \         /\  \          /\  \       /\  \         /\  \         /\  \         /\  \    
    /::\  \       /::\  \         \:\  \     /::\  \       /::\  \        \:\  \       /::\  \   
   /:/\:\  \     /:/\:\  \    ___ /::\__\   /:/\:\  \     /:/\:\  \        \:\  \     /:/\ \  \  
  /:/  \:\  \   /::\~\:\__\  /\  /:/\/__/  /::\~\:\  \   /:/  \:\  \       /::\  \   _\:\~\ \  \ 
 /:/__/ \:\__\ /:/\:\ \:|__| \:\/:/  /    /:/\:\ \:\__\ /:/__/ \:\__\     /:/\:\__\ /\ \:\ \ \__\
 \:\  \ /:/  / \:\~\:\/:/  /  \::/  /     \:\~\:\ \/__/ \:\  \  \/__/    /:/  \/__/ \:\ \:\ \/__/
  \:\  /:/  /   \:\ \::/  /    \/__/       \:\ \:\__\    \:\  \         /:/  /       \:\ \:\__\  
   \:\/:/  /     \:\/:/  /                  \:\ \/__/     \:\  \        \/__/         \:\/:/  /  
    \::/  /       \::/__/                    \:\__\        \:\__\                      \::/  /   
     \/__/         ~~                         \/__/         \/__/                       \/__/    
'''

level_3_obj = ["airlock", "table", "closet", "window"]

def return_isobject(stroke):
	for obj_unit2 in level_3_obj:
		if stroke.find(obj_unit2) != -1:
			#print(stroke + ";" + obj_unit2)
			if obj_unit2 == "airlock":
				return "/obj/machinery/airlock"
			if obj_unit2 == "table":
				return "/obj/structure/table"
			if obj_unit2 == "closet":
				return "/obj/structure/closet"	
			if obj_unit2 == "window":	
				return "/turf/simulated/wall/newicon/window"
	return ""

'''
      ___           ___           ___           ___     
     /\  \         /\  \         /\  \         /\  \    
    /::\  \       /::\  \       /::\  \       /::\  \   
   /:/\:\  \     /:/\:\  \     /:/\:\  \     /:/\:\  \  
  /::\~\:\  \   /::\~\:\  \   /::\~\:\  \   /::\~\:\  \ 
 /:/\:\ \:\__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/\:\ \:\__\
 \/__\:\/:/  / \/_|::\/:/  / \:\~\:\ \/__/ \/__\:\/:/  /
      \::/  /     |:|::/  /   \:\ \:\__\        \::/  / 
      /:/  /      |:|\/__/     \:\ \/__/        /:/  /  
     /:/  /       |:|  |        \:\__\         /:/  /   
     \/__/         \|__|         \/__/         \/__/    

'''
def return_isoarea(stroke): ###ha-ha-ha
	return "/area"

'''
      ___           ___           ___     
     /\__\         /\  \         /\  \    
    /::|  |       /::\  \       /::\  \   
   /:|:|  |      /:/\:\  \     /:/\:\  \  
  /:/|:|__|__   /:/  \:\  \   /::\~\:\__\ 
 /:/ |::::\__\ /:/__/ \:\__\ /:/\:\ \:|__|
 \/__/~~/:/  / \:\  \ /:/  / \:\~\:\/:/  /
       /:/  /   \:\  /:/  /   \:\ \::/  / 
      /:/  /     \:\/:/  /     \:\/:/  /  
     /:/  /       \::/  /       \::/__/   
     \/__/         \/__/         ~~       
     
'''
def return_isomob(stroke): ###ha-ha-ha
	return "/mob"


def remove_replace(stroke):
	for atom in level_1:
		superstroke = ""
		if stroke.find(atom) != -1:

			if atom == "turf":
				superstroke = return_isoturf(stroke)
				if superstroke == "":
					stroke = "/turf/space"

			if atom == "obj":
				superstroke = return_isobject(stroke)
				if superstroke == "":
					stroke = "/obj"

			if atom == "area":
				superstroke = return_isoarea(stroke)

			if atom == "mob":
				superstroke = return_isomob(stroke)
					
			if superstroke != "":
				stroke = superstroke
	#print(stroke)
	return stroke
				
def processline(line):
	i = 0
	while i < 7: ####МЕНЯЕМ ЭТО ЧИСЛО. КОЛИЧЕСТВО {переменная = залупа} на одном тайле
		i += 1
		beginline = line.find('{') #берем только то, что находится между скобками
		endline = line.find('}')
		if(beginline != -1 and endline != -1):
			workline = line[beginline:endline+1]
			line = line.replace(str(workline), "")
			#print(line + ";" + workline)
	
	beginline = line.find('(') #берем только то, что находится между скобками
	endline = line.find(')')
	if(beginline != -1 and endline != -1):
		workline = line[beginline+1:endline] #дальше идет работа с разделителем
		pathlines = workline.split(",")
		for path in pathlines:
			replacer = remove_replace(path)
			#print(path + " & " + replacer)
			line = line.replace(str(path), replacer)
		#а теперь пихуем обратно уже реплейснутую строку
		dots = ','
		worklineold = workline
		workline = dots.join(pathlines)
		
		#line[beginline:endline] = workline
		#print(line)
	#print (line)
		
	return line
		
fd = f.read()
readmap = fd.splitlines()
f.close()
f = open("1.txt", "w+")

for line in readmap:
	beginline = line.find('(') #берем только то, что находится между скобками
	endline = line.find(')')
	if(beginline != -1 and endline != -1):
		f.write("%s\n" % processline(line))
	else:
		break

f.close()

print(" _____               _     _         _ ")
time.sleep(1)
print("|     |___ _____ ___| |___| |_ ___ _| |")
time.sleep(1)
print("|   --| . |     | . | | -_|  _| -_| . |")
time.sleep(1)
print("|_____|___|_|_|_|  _|_|___|_| |___|___|")
time.sleep(1)
print("                |_|                    ")

