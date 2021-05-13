async function loadJSON() {
    let requestJSON = new Request('county-data/json/json_for_search.json');
    let fetchResponse = await fetch(requestJSON);
    let jsonValue = await fetchResponse.json();
    var resolvedJSONValue = Promise.resolve(jsonValue);
    console.log(resolvedJSONValue.typeof);
    // here I get undefined for type and I wasn't sure if that should be the case
    return resolvedJSONValue;
}

// stateButton.addEventListener("click", () => {
//   }

var object = Object.keys(resolvedJSONValue);
console.log(object);

stateButton.addEventListener("click", () => {
  // things to come 
}; 







