click_start=1-- this starts the clickfunction
buttons={}--this table initially holds the values from the buttons

--button drawing function
function buttondraw(txt,color,fill)
	local temp;
	if fill==0 then
		temp="${ color " .. color .. " }" ..  txt .. "${draw_borders false}"
	elseif fill==1 then
		temp="${ color " .. color .. " }" ..  txt .. "${draw_borders false}"
	end
	return temp
end--of buttondraw function
function xout(txj)--c,a,f,fs,x,y,txt,j ##################################################
	c=nil
	c=(txj.c or default_color)
	a=nil
	a=(txj.a or default_alpha)
	f=nil
	f=(txj.f or default_font)
	fs=nil
	fs=(txj.fs or default_font_size)
	txt=nil
	txt=(txj.txt or "set txt")
	j=nil
	j=(txj.j or "l")
		local function col(c,a)
			return ( (c/0x10000) % 0x100)/255,( (c/0x100) % 0x100)/255,(c % 0x100)/255,a
		end--local function
	local text=string.gsub(txt," ","_")
	local wx=extents.width
	if j=="l" then
		adx=wx
	elseif j=="c" then
		adx=wx/2
	elseif j=="r" then
		adx=0
	end
	nextx=nil
	nextx=adx+x
	return nextx
end--function xout ###################################################################
function out(tx)--####################################################################
	c=nil
	c=(tx.c or default_color)
	a=nil
	a=(tx.a or default_alpha)
	f=nil
	f=(tx.f or default_font)
	fs=nil
	fs=(tx.fs or default_font_size)
	x=nil
	x=(tx.x or 0)
	y=nil
	y=(tx.y or 0)
	txt=nil
	txt=(tx.txt or "set txt")
end--function out ###################################################################
function image(im)--#################################################################
	x=nil
	x=(im.x or 0)
	y=nil
	y=(im.y or 0)
	w=nil
	w=(im.w or default_image_width)
	h=nil
	h=(im.h or default_image_height)
	file=nil
	file=tostring(im.file)
	if file==nil then print("set image file") end
	---------------------------------------------
	local show = imlib_load_image(file)
	if show == nil then return end
		imlib_context_set_image(show)
	if tonumber(w)==0 then 
		width=imlib_image_get_width() 
	else
		width=tonumber(w)
	end
	if tonumber(h)==0 then 
		height=imlib_image_get_height() 
	else
		height=tonumber(h)
	end
	imlib_context_set_image(show)
	local scaled=imlib_create_cropped_scaled_image(0, 0, imlib_image_get_width(), imlib_image_get_height(), width, height)
	imlib_free_image()
	imlib_context_set_image(scaled)
	imlib_render_image_on_drawable(x, y)
	imlib_free_image()
	show=nil
end--function image ##################################################################
--clickfunction, this runs xdotool and xwininfo and reads the coordinates of clicks
function clickfunction()
	--start click logging and calculations ##########################################
	if click_start==1 then
		xdot=conky_parse("${if_running xdotool}1${else}0${endif}")
	if tonumber(xdot)==1 then
		os.execute("killall xdotool && echo 'xdo killed' &")
	end
	os.execute("xdotool search --name 'clicky' behave %@ mouse-click getmouselocation >> /tmp/xdo &")
	local f = io.popen("xwininfo -name 'clicky' | grep 'Absolute'")
	geometry = f:read("*a")
	f:close()
	local geometry=string.gsub(geometry,"[\n]","")
	s,f,abstlx=string.find(geometry,"X%p%s*(%d*)")
	s,f,abstly=string.find(geometry,"Y%p%s*(%d*)")
	click_start=nil
	end--if click_start=1 ######################################
	--click calculations #################################
	local f=io.open("/tmp/xdo")
	click=f:read()
	f:close()
	if click~=nil then
		local f = io.open("/tmp/xdo","w")
		f:write("")
		f:close() 
	end--if click=nil
	if click==nil then click="x:0 y:0 " end
	--print (click)
	local s,f,mousex=string.find(click,"x%p(%d*)%s")
	local s,f,mousey=string.find(click,"y%p(%d*)%s")
	localx=tonumber(mousex)-abstlx
	localy=tonumber(mousey)-abstly
	--get now location
	os.execute("xdotool getmouselocation > /tmp/xdonow ")
	local f=io.open("/tmp/xdonow")
	mousenow=f:read()
	f:close()
	local s,f,mousenowx=string.find(mousenow,"x%p(%d*)%s")
	local s,f,mousenowy=string.find(mousenow,"y%p(%d*)%s")
	localnowx=tonumber(mousenowx)-abstlx
	localnowy=tonumber(mousenowy)-abstly
	--END CLICK CALCULATIONS #################################
	return localx,localy,localnowx,localnowy
end--click function