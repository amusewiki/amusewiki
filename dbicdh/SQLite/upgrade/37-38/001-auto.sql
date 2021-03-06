-- Convert schema '/home/melmoth/amw/AmuseWikiFarm/dbicdh/_source/deploy/37/001-auto.yml' to '/home/melmoth/amw/AmuseWikiFarm/dbicdh/_source/deploy/38/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE text_part (
  title_id integer NOT NULL,
  part_index varchar(16) NOT NULL,
  part_level integer NOT NULL,
  part_title text NOT NULL,
  part_size integer NOT NULL,
  toc_index integer NOT NULL,
  part_order integer NOT NULL,
  PRIMARY KEY (title_id, part_index),
  FOREIGN KEY (title_id) REFERENCES title(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX text_part_idx_title_id ON text_part (title_id);

;
ALTER TABLE title ADD COLUMN text_qualification varchar(255);

;
ALTER TABLE title ADD COLUMN text_size integer NOT NULL DEFAULT 0;

;

COMMIT;

