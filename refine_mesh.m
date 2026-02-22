function [new_nodes, new_elements] = refine_mesh(nodes, elements, h)
    % Cette fonction raffine le maillage en fonction de la taille de pas h.
    % Il s'agit d'une fonction de substitution simple. Il faudrait la
    % remplacer par une méthode correcte de raffinement de maillage.
    
    % Pour l'instant, on ne fait pas de raffinement et on retourne les mêmes
    % nodes et elements.
    new_nodes = nodes;
    new_elements = elements;
end
