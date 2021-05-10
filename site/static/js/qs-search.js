import {quickScore} from "quick-score";

const qs = new QuickScore(["Santa Clara County, CA", "San Mateo County, CA", "Santa Cruz County, CA", "Marin County, CA"]);
const results = qs.search("San");
