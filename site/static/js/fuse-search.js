import Fuse from "https://cdn.jsdelivr.net/npm/fuse.js@6.4.6/dist/fuse.esm.js";

const countyNames = [
    {
        county: "Santa Clara",
    },
    {
        county: "Santa Cruz",
    },
    {
        county: "Marin",
    },
    ];

    const options = {
    includeScore: true,
    findAllMatches: true,
    keys: ["county"],
    };

    const searchInput = document.querySelector("input");
    // console.log("search input: ", searchInput);

    searchInput.addEventListener("input", search);
    // search();
    
    function search() {
    const fuse = new Fuse(countyNames, options);
    const result = fuse.search(searchInput.value).value;
    document.querySelector(".dropdown").innerHTML = result;
    }