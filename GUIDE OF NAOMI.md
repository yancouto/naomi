=====
NAOMI
=====


#####################
# OVERVIEW SIMPLES: #
#####################

	Naomi é um sidescroller plataformer, feito originalmente em HaxeFlixel. 	O jogo se passa em um castelo,
no qual seu objetivo é guiar uma alma até seu topo. A mecânica central do jogo é vocÊ "jogar" sua alma de corpo
para corpo, possuindo-os e usando eles para avançar.
Suas habilidades dependem do corpo hospedeiro atual, que variam desde "ter mais vida" até "double jumping". Entretanto
cada corpo vai decaindo ao ser hospedado por muito tempo, podendo até ser destruido completamente, destruindo-o junto
com a alma dentro dele (Naomi)

	O jogo utiliza elementos básicos de paltaformers, como plataformas móveis, botões/alavancas, portas com timers, etc, até
mais específicos como espelhos que refletem sua alma ou paredes que o jogador não atravessa, mas pode jogar sua alma por ela.

###################
# GAMEPLAY/DESIGN #
###################
	

	NAOMI/ MECÂNICAS COM A ALMA:

		-Pode habitar corpos de outros seres vivos.
		-Usa o mouse para "lançar sua alma" do corpo
			-Atingindo um ser vivo passa a habita-lo
			-Não atingindo volta pro corpo em uma linha reta ou desaparece /* a decidir */
			-Almas ao atingir paredes "normais" volta instantaneamente
		-Enquanto habita um corpo, sua "vida" vai decaindo
			-Uma barra de vida na interface diminui
			-Efeitos visuais no sprite conforme o corpo vai "morrendo" /* a decidir */
			-Ao sair de um corpo a vida do original continua a mesma, com o corpo parado
			-Se a vida de um corpo ao sair for menor que 15%  (balancear)  o corpo morre
			-Se voce continua em um corpo e sua vida abaixa para 0% voce morre junto com o corpo (game over)
				-Quando a vida abaixa para 0% o jogo fica em slow motion, dando alguns segundos para voce trocar de corpo /* a decidir */

		-Cada ser vivo terá alguma caracteristica única, vista a seguir. Todos andam lateralmente.


	Divisão entre os inimigos que você pode habitar e os elementos inanimáveis dentro do jogo...

   ~~~~~~~~
	INIMIGOS
	~~~~~~~~

	HEAVY:
		
		-Vida alta
			-Aguenta bastante dano/Naomi pode habitá-los por mais tempo
		-Pesado em relação aos outros inimigos
			-Move balanças ao seu favor
			-Se cair de certa altura em chão frágil quebra ele
		-Grande
			-Nao pode passar em passagens estreitas
		-Pulo pequeno

	ROGUE:

		-Vida média
		-Peso médio
			-Influencia pouco em balanças
			-Pode apertar botoões comuns
		-Rápido
		-Pulo alto
		-Double Jump
		-Wall Jump

	RAT:

		-Vida curta
			-Não aguenta dano e pode ser habitado por pouco tempo
		-Pequeno
			-Pode andar por passagens pequenas
		-Leve
			-Não pode ativar botões no chão com seu peso
		-Não pode usar alavancas ou coisas do tipo
		-Não pode pular

	~~~~~~~
	OBJETOS
	~~~~~~~

	MOVING PLATFORMS:
		
		-Plataformas que se movem em um loop
		-Podem ou não ser "atravessaveis" de baixo pra cima ou vice-versa por comando do jogador

	GLASS:
		
		-Jogador não atravessa, como qualquer outra parede
		-Almas podem ser jogados através delas.

	MIRRORS:

		-Almas que o atingem são refletidas no ângulo correto

	BUTTONS:

		-São pressionáveis por seres vivos com peso médio ou acima
		-Mantém seu comando de ativo somente enquanto tiver alguem sobre eles.
		-Podem ser de tamanho grande, somente podendo ser apertadas por pesos grandes /* a decidir */

	

