import { readFileSync } from 'node:fs';
import { marked } from 'marked';
import { gfmHeadingId } from 'marked-gfm-heading-id';

marked.use(gfmHeadingId());
process.stdout.write(marked.parse(readFileSync(0, 'utf8')));
