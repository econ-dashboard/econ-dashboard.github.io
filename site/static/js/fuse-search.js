import Fuse from 'fuse.js';

const countyNames = [
    {
        "county": "Santa Clara"
    },
    {
        "county": "Marin" 
    }
]

const fuse = new Fuse(counties, {
    keys: ['county']
});

const results = fuse.search('Santa')