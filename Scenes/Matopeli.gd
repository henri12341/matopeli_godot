extends Node2D

var mato_osa = preload("res://Scenes/Mato.tscn")
var syotti = preload("res://Scenes/syotti.tscn")
var madon_osat = []
var suunta = "Oikea"
var ruudun_koko = 30
var liikkumisnopeus = 0.2 # Yksikkö sekuntti
var kulunut_aika = 0
var kasvata_matoa = false

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for i in range(0,3):
		var mato_osa_instance = mato_osa.instance()
		get_node(".").add_child(mato_osa_instance)
		mato_osa_instance.position = Vector2(255 + i*ruudun_koko ,285)
		madon_osat.append(mato_osa_instance)
	
	lisaa_syotti()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("move_down"):
		if suunta != "Ylos":
			suunta = "Alas"
	if Input.is_action_pressed("move_left"):
		if suunta != "Oikea":
			suunta = "Vasen"
	if Input.is_action_pressed("move_right"):
		if suunta != "Vasen":
			suunta = "Oikea"
	if Input.is_action_pressed("move_up"):
		if suunta != "Alas":
			suunta = "Ylos"
	
	liiku(delta)
	tormaysten_tarkistus()


func liiku(delta):
	kulunut_aika += delta
	if kulunut_aika > liikkumisnopeus:	
		kulunut_aika = 0
		var liikutettava_madon_osa
		
		if !kasvata_matoa:
			liikutettava_madon_osa = madon_osat.pop_back()
		else:
			liikutettava_madon_osa = mato_osa.instance()
			get_node(".").add_child(liikutettava_madon_osa)
			kasvata_matoa = false
		
		var sijainti
		for osa in madon_osat:
			sijainti = osa.position # Otetaan ensimmäisen madon osan sijainti
			break
		print(sijainti)
		
		if suunta == "Oikea":
			liikutettava_madon_osa.position = Vector2(sijainti.x - ruudun_koko, sijainti.y)
		if suunta == "Vasen":
			liikutettava_madon_osa.position = Vector2(sijainti.x + ruudun_koko, sijainti.y)
		if suunta == "Ylos":
			liikutettava_madon_osa.position = Vector2(sijainti.x , sijainti.y - ruudun_koko)
		if suunta == "Alas":
			liikutettava_madon_osa.position = Vector2(sijainti.x , sijainti.y + ruudun_koko)
		madon_osat.push_front(liikutettava_madon_osa)


func tormaysten_tarkistus():
	var bodies = madon_osat[0].get_colliding_bodies()
	for body in bodies:
		print(body)
		if body.is_in_group("Mato"):
			get_tree().reload_current_scene()
		if body.is_in_group("Syotti"):
			body.queue_free()
			lisaa_syotti()
			kasvata_matoa = true
		if body.is_in_group("Seina"):
			get_tree().reload_current_scene()


func lisaa_syotti():
	var syotti_instance = syotti.instance()
	get_node(".").add_child(syotti_instance)
	var random_x =  rng.randi_range(0, 19) * ruudun_koko + 15
	var random_y = rng.randi_range(0, 19) * ruudun_koko + 15
	print(str(random_x) + ", " + str(random_y))
	syotti_instance.position = Vector2(random_x , random_y)
