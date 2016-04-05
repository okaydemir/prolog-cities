%This predicate is DIRECTIONAL and it doesn’t imply a reverse connection from ’TargetCity’ to ’SourceCity’.
road( london, paris, 459 ).
road( paris, berlin, 1054 ).
road( paris, barcelona, 1036 ).
road( barcelona, milano, 981 ).
road( milano, budapest, 960 ).
road( berlin, budapest, 874 ).
road( budapest, istanbul, 1319 ).

%The language predicate represents that the language ’Language’ is spoken in the ’City
language( london, english ).
language( paris, french ).
language( paris, arabic ).
language( berlin, german ).
language( berlin, turkish ).
language( barcelona, spanish ).
language( barcelona, catalan ).
language( barcelona, italian ).
language( milano, italian ).
language( budapest, hungarian ).
language( istanbul, turkish ).
language( istanbul, arabic ).

 
/* true for two diﬀerent cities ’City1’ and ’City2’
that share the common ’Language’
*/
communicate_with( City1, City2, Language ) :-
language(City1,Language),
language(City2,Language),%same language for both cities must be true
City1 \= City2. %we dont want same country in results
	
%true for two diﬀerent cities ’City1’ and ’City2’ that share a common language.
	
communicate( City1, City2 ) :-
language(City1,Language),
language(City2,Language), %same language ,we dont care which, for both cities must be true
City1 \= City2.  %we dont want same country in results
	
	
% ﬁnds all the cities in which ’Language’ is spoken and returns a list ’CityList’.
cities_of_language(Language, CityList):-
findall(X, language(X,Language), CityList). %self explaining
	
%ﬁnds all the languages that are spoken in ’City’ and puts them into ’LanguageList’.	
languages_of_city( City, LanguageList ):-
findall(X, language(City,X), LanguageList). %self explaining

%Two cities ’City1’ and ’City2’ are connected if there is road between them
is_connected( City1, City2 ):-
road(City1,City2,_). %check if there is a direct road

is_connected( City1, City2 ):-
road(City1,X, _),
is_connected(X,City2). %check if there is an indirect road over other cities with recursive call

%The ’Distance’ between the connected cities ’City1’ and ’City2’.
distance( City1, City2, Distance  ):-
road(City1,City2,Distance). %if there is a direct road we know the distance

distance( City1, City2, Distance):-
road(City1,Z,D1),
distance(Z,City2,D2),%recursive call to find indirect roads
Distance is D1+D2.%if there is not a direct road add distances

% ﬁnds all the cities that are connected to ’City’ and puts them into ’CityList’.

connected_cities( City,CityList):-
setof(Y, is_connected(City, Y), CityList).%setoff instead of findall to not have duplicates

% ﬁnds the minimum ’Distance’ between ’City1’ and ’City2’
minimum_distance(City1, City2, Distance):- 
findall(X, distance( City1, City2,X), LanguageList),%find all distances
sort(LanguageList, LLS),%sort the distance list
LLS = [A|_], %get first element of sorted list which is minimum
Distance is A.
