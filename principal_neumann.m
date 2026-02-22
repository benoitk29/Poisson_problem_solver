% =====================================================
%
%
% une routine pour la mise en oeuvre des EF P1 Lagrange
% pour l'equation de Laplace suivante, avec conditions de
% Neumann sur le maillage nom_maillage.msh
%
% | -\Delta u + u= f,   dans \Omega
% |         du/dn = 0,   sur le bord
%
% =====================================================


% lecture du maillage et affichage
% ---------------------------------
nom_maillage = 'geomCarre.msh';
[Nbpt,Nbtri,Coorneu,Refneu,Numtri,Reftri,Nbaretes,Numaretes,Refaretes]=lecture_msh(nom_maillage);

% ----------------------
% calcul des matrices EF
% ----------------------

% declarations
% ------------
KK = sparse(Nbpt,Nbpt); % matrice de rigidite
%MM = sparse(Nbpt,Nbpt); % matrice de masse
LL = zeros(Nbpt,1);     % vecteur second membre
MM = zeros(Nbpt,Nbpt); 
% boucle sur les triangles
% ------------------------
for l=1:Nbtri
    % Coordonnees des sommets du triangle 
    S1=Coorneu(Numtri(l,1), :);
    S2=Coorneu(Numtri(l,2), :);
    S3=Coorneu(Numtri(l,3), :);
    % calcul des matrices élementaires du triangle l

    Kel=matK_elem(S1, S2, S3);
    Mel=matM_elem(S1, S2, S3);
 % On fait l'assemmblage de la matrice globale et du second membre
    for i=1:3
        I= Numtri(l,i);
        for j=1:3
            J=Numtri(l,j);
            %MM(I,J)= MM(I,J)+Mel(i,j);
            MM(I,J)= 0;
            KK(I,J)= KK(I,J)+Kel(i,j);
        end
    end

   


end % for l

% Calcul du second membre L
% -------------------------

% utiliser la routine f.m
FF = f(Coorneu(:,1),Coorneu(:,2));
LL = MM*FF;

% inversion
% ----------
UU = (MM+KK)\LL;
UU_exact = cos(pi*Coorneu(:,1)).*cos(2*pi*Coorneu(:,2));
% visualisation
% -------------
affiche(UU, Numtri, Coorneu, sprintf('Neumann - %s', nom_maillage));
%Pour comparer
affiche(UU_exact, Numtri, Coorneu, sprintf('Neumann - %s', nom_maillage));
validation = 'oui';
% validation
% ----------
if strcmp(validation,'oui')
%-----
%     UU_exact = cos(pi*Coorneu(:,1)).*cos(2*pi*Coorneu(:,2));
%     % Calcul de l erreur L2
%     error_L2 = sqrt((UU_exact - UU)' * MM * (UU_exact - UU));
%     exact_L2 = sqrt(UU_exact' * MM * UU_exact);
%     erreur_relative_L2 = error_L2 / exact_L2
%     fprintf('L2 error: %e\n', error_L2);
%     fprintf('Relative L2 error: %e\n', erreur_relative_L2);
% 
% %     h_valeurs = [ 0.2 0.1, 0.05, 0.025, 0.0125]; 
%     log_h_valeurs = log10(1 / 0.2) % log(1/h)
%     log_errors = log10(erreur_relative_L2);
% 
% %-----
%     % Calcul de l erreur H1
%     error_H1 = sqrt((UU_exact - UU)' * KK * (UU_exact - UU));
%     exact_H1 = sqrt(UU_exact' * KK * UU_exact);
%     erreur_relative_H = error_H1 / exact_H1 
%     fprintf('H1 error: %e\n', error_H1);
%     fprintf('Relative H1 error: %e\n', erreur_relative_H);
% 
% %     h_valeurs = [ 0.2 0.1, 0.05, 0.025, 0.0125]; 
%     log_h_valeurs_H1 = log10(1 / 0.2) % log(1/h)
%     log_errors_H1 = log10(erreur_relative_H);
%     
%     figure;
%     plot(log_h_valeurs, log_errors, 'o', 'DisplayName', 'L2 Error');
%     hold on;
%     plot(log_h_valeurs_H1, log_errors_H1, 'x', 'DisplayName', 'H1 Error');
%     hold off;
% 
%     % Labels and title
%     xlabel('log(1/h)');
%     ylabel('log(relative error)');
%     title('L2 and H1 relative errors for h = 0.2');
%     legend show;
%     grid on;

% Données
h_valeurs = [0.2, 0.1, 0.05, 0.025];
erreur_relative_L2 = [0.1117, 0.0267, 0.0065, 0.0016];
erreur_relative_H = [0.0906, 0.0257, 0.0081, 0.0025];

% Calculer log(1/h)
log_h_valeurs = log10(1 ./ h_valeurs);

% Calculer le log des erreurs relatives
log_errors_L2 = log10(erreur_relative_L2);
log_errors_H1 = log10(erreur_relative_H);

% Effectuer la régression linéaire
% Polyfit retourne les coefficients de la droite de régression
% Le premier argument est le vecteur de x (log_h_valeurs)
% Le deuxième argument est le vecteur de y (log_errors_L2 ou log_errors_H1)
% Le troisième argument est le degré du polynôme (1 pour linéaire)

% Coefficients pour L2 Error
p_L2 = polyfit(log_h_valeurs, log_errors_L2, 1);
% Coefficients pour H1 Error
p_H1 = polyfit(log_h_valeurs, log_errors_H1, 1);

% Évaluer les valeurs de la droite de régression
% polyval retourne les valeurs du polynôme évaluées en x
regression_L2 = polyval(p_L2, log_h_valeurs);
regression_H1 = polyval(p_H1, log_h_valeurs);

% Tracer les données et les droites de régression
figure;
plot(log_h_valeurs, log_errors_L2, '-o', 'DisplayName', 'L2 Error');
hold on;
plot(log_h_valeurs, log_errors_H1, '-x', 'DisplayName', 'H1 Error');
plot(log_h_valeurs, regression_L2, '--', 'DisplayName', 'L2 Regression Line');
plot(log_h_valeurs, regression_H1, '--', 'DisplayName', 'H1 Regression Line');
hold off;

% Étiquettes et titre
xlabel('log(1/h)');
ylabel('log(relative error)');
title('Convergence de L2 et erreur relative de H1');
legend show;
grid on;

% Affichage des coefficients
disp('Coefficients de la régression pour L2 Error:');
disp(p_L2);
disp('Coefficients de la régression pour H1 Error:');
disp(p_H1);



    % attention de bien changer le terme source (dans FF)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        fin de la routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%24

