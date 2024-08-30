  function searchMovies() {
                        var searchTerm = document.getElementById('searchBar').value;
                        var suggestions = document.getElementById('suggestions');

                        if (searchTerm.length < 2) {
                            suggestions.style.display = 'none';
                            return;
                        }

                        var xhr = new XMLHttpRequest();
                        xhr.open('GET', 'search?term=' + encodeURIComponent(searchTerm), true);
                        xhr.onload = function() {
                            if (xhr.status === 200) {
                                var results = JSON.parse(xhr.responseText);
                                suggestions.innerHTML = '';
                                if (results.length > 0) {
                                    results.forEach(function(movie) {
                                        var li = document.createElement('li');
                                        li.textContent = movie.title;
                                          li.classList.add('py-2', 'px-4', 'border-b', 'border-gray-300', 'hover:bg-gray-200', 'cursor-pointer');
                                        li.onclick = function() {
                                            window.location.href = 'movieDetails.jsp?movie_id=' + movie.movie_id;
                                        };
                                        suggestions.appendChild(li);
                                    });
                                    suggestions.style.display = 'block';
                                } else {
                                    suggestions.style.display = 'none';
                                }
                            }
                        };
                        xhr.send();
                    }

                    function showAllMovies() {
                        var searchTerm = document.getElementById('searchBar').value;
                        if (searchTerm.length >= 2) {
                            window.location.href = 'searchResults.jsp?term=' + encodeURIComponent(searchTerm);
                        }
                    }