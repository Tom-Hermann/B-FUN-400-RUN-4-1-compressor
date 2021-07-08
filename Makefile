##
## EPITECH PROJECT, 2021
## B-FUN-400-RUN-4-1-compressor-romain.grondin
## File description:
## Makefile
##


B_PATH	=	"$(shell stack path --local-install-root)"
NAME	=	imageCompressor
RM		=	rm -rf

all:
	stack build
	cp $(B_PATH)/bin/$(NAME)-exe $(NAME)

clean:
	stack clean

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re